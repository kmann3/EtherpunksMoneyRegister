//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftData
import SwiftUI

struct DashboardView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(PathStore.self) var router
    @Query(sort: [SortDescriptor(\Account.name, comparator: .localizedStandard)]) var accountList: [Account]

    @Query(
        filter: #Predicate<AccountTransaction> { transaction in
            if transaction.pendingOnUTC == nil {
                if transaction.clearedOnUTC == nil {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        ,sort: [SortDescriptor(\AccountTransaction.createdOnUTC)]
    ) var reservedTransactions: [AccountTransaction]

    @Query(
        filter: #Predicate<AccountTransaction> { transaction in
            if transaction.pendingOnUTC != nil {
                if transaction.clearedOnUTC == nil {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        ,sort: [SortDescriptor(\AccountTransaction.createdOnUTC)]
    ) var pendingTransactions: [AccountTransaction]

    var upcomingTransactions: [AccountTransaction] = []
    var paydayTransactions: [AccountTransaction] = []

    var body: some View {
        VStack {
            HStack {
                VStack {
                    List(accountList) { account in
                        AccountListItemView(acctData: account)
                    }
                    Spacer()
                }
                Spacer()

                VStack {
                    List {
                        Section(header: Text("Reserved Transactions")) {
                            ForEach(reservedTransactions) { reserved in
                                TransactionListItemView(transaction: reserved, showBalance: false)
                            }
                        }
                    }
                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(pendingTransactions) { pending in
                                TransactionListItemView(transaction: pending, showBalance: false)
                            }
                        }
                    }
                    Spacer()
                }

                Spacer()
                VStack {
                    List {
                        Section(header: Text("Payday")) {
                            HStack {
                                Spacer()
                                Button {
                                    // If items are selected, deposit money into account. Should do this as pending? Or cleared? Or ask?
                                } label: {
                                    Text("Paid")
                                }
                                .opacity(1)
                            }

                            ForEach(paydayTransactions) { payday in
                                TransactionListItemView(transaction: payday, showBalance: false, renderBackgroundColor: false)
                                    .onTapGesture {
                                        // Select the box and show the "reserve" button
                                    }
                            }
                        }
                    }
                    List {
                        Section(header: Text("Upcoming Recurring Transactions")) {
                            HStack {
                                Spacer()
                                Button {
                                    // If items are selected, flag all the selected ones as reserved
                                } label: {
                                    Text("Reserve")
                                }
                                .opacity(1)
                            }

                            ForEach(upcomingTransactions) { upcoming in
                                TransactionListItemView(transaction: upcoming, showBalance: false, renderBackgroundColor: false)
                                    .onTapGesture {
                                        // Select the box and show the "reserve" button
                                    }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(Previewer().container)
        .environment(PathStore())
        #if os(macOS)
            .frame(width: 900, height: 500)
        #endif
}
