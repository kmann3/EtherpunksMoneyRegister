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

    @State private var selectedPaydays = [RecurringTransaction]()
    @State private var selectedUpcomingTransactions: [RecurringTransaction] = []

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
                                    //Account.reserveList(list: selectedPaydays, account: <#Account#>, context: modelContext)
                                } label: {
                                    Text("Paid")
                                }
                                .opacity(1)
                            }

                            ForEach(paydayTransactions, id: \.self) { payday in
                                Dashboard_RecurringViewItem(recurringItem: payday, isSelected: self.selectedPaydays.contains(payday)) {
                                    if self.selectedPaydays.contains(payday) {
                                        self.selectedPaydays.removeAll(where: { $0 == payday })
                                    } else {
                                        self.selectedPaydays.append(payday)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        self.selectedPaydays = []
                    }
                    List {
                        Section(header: Text("Upcoming Recurring Transactions")) {
                            HStack {
                                Spacer()
                                Button {
                                    //RecurringTransaction.reserveList(list: selectedUpcomingTransactions, context: modelContext)
                                } label: {
                                    Text("Reserve")
                                }
                                .opacity(1)
                            }

                            ForEach(upcomingTransactions, id: \.self) { upcoming in
                                Dashboard_RecurringViewItem(recurringItem: upcoming, isSelected: self.selectedUpcomingTransactions.contains(upcoming)) {
                                    if self.selectedUpcomingTransactions.contains(upcoming) {
                                        self.selectedUpcomingTransactions.removeAll(where: { $0 == upcoming })
                                    } else {
                                        self.selectedUpcomingTransactions.append(upcoming)
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        self.selectedUpcomingTransactions = []
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
