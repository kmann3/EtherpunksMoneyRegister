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
            if transaction.clearedOnUTC == nil {
                if transaction.pendingOnUTC == nil {
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
            if transaction.clearedOnUTC == nil {
                if transaction.pendingOnUTC != nil {
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

    @Query(
        filter: RecurringTransaction.transactionTypeFilter(type: .debit)
        ,sort: [SortDescriptor(\RecurringTransaction.nextDueDate)]
    ) var upcomingTransactions: [RecurringTransaction]

    @Query(
        filter: RecurringTransaction.transactionTypeFilter(type: .credit)
        ,sort: [SortDescriptor(\RecurringTransaction.nextDueDate)]
    ) var paydayTransactions: [RecurringTransaction] = []

    var body: some View {
        VStack {
            HStack {
                VStack {
                    List(accountList) { account in
                        Dashboard_AccountViewItem(acctData: account)
                            .onTapGesture {
                                router.navigateTo(
                                    route: .transaction_List(account: account))
                            }
                    }
                    Spacer()
                }
                Spacer()

                VStack {
                    List {
                        Section(header: Text("Reserved Transactions")) {
                            ForEach(reservedTransactions) { reserved in
                                Dashboard_TransactionViewItem(transaction: reserved)
                            }
                        }
                    }
                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(pendingTransactions) { pending in
                                Dashboard_TransactionViewItem(transaction: pending)
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 200)

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
                                HStack {
                                    Text(payday.name)
                                    Spacer()
                                    Text(payday.nextDueDate?.toSummaryDate() ?? "")
                                }
//                                TransactionListItemView(transaction: payday, showBalance: false, renderBackgroundColor: false)
//                                    .onTapGesture {
//                                        // Select the box and show the "reserve" button
//                                    }
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
                                HStack {
                                    Text(upcoming.name)
                                    Spacer()
                                    Text(upcoming.nextDueDate?.toSummaryDate() ?? "")
                                }
//                                TransactionListItemView(transaction: upcoming, showBalance: false, renderBackgroundColor: false)
//                                    .onTapGesture {
//                                        // Select the box and show the "reserve" button
//                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 400)
            }
        }
    }
}

#Preview {
    let p = Previewer()
    DashboardView()
        .modelContainer(p.container)
        .environment(PathStore())
        #if os(macOS)
            .frame(width: 900, height: 500)
        #endif
}
