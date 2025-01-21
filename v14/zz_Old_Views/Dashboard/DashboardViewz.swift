////
////  DashboardViewz.swift
////  EtherpunksMoneyRegister.v14
////
////  Created by Kennith Mann on 11/19/24.
////
//
//import SwiftData
//import SwiftUI
//
//struct DashboardViewz: View {
//    @Environment(\.modelContext) var modelContext
//    @Environment(PathStore.self) var router
//    @Query(sort: [SortDescriptor(\Account.name, comparator: .localizedStandard)]) var accountList: [Account]
//
//    @Query(
//        filter: #Predicate<AccountTransaction> { transaction in
//            if transaction.clearedOnUTC == nil {
//                if transaction.pendingOnUTC == nil {
//                    return true
//                } else {
//                    return false
//                }
//            } else {
//                return false
//            }
//        }
//        ,sort: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
//    ) var reservedTransactions: [AccountTransaction]
//
//    @Query(
//        filter: #Predicate<AccountTransaction> { transaction in
//            if transaction.clearedOnUTC == nil {
//                if transaction.pendingOnUTC != nil {
//                    return true
//                } else {
//                    return false
//                }
//            } else {
//                return false
//            }
//        }
//        ,sort: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)]
//    ) var pendingTransactions: [AccountTransaction]
//
//    @Query(
//        filter: RecurringTransaction.transactionTypeFilter(type: .debit)
//        ,sort: [SortDescriptor(\RecurringTransaction.nextDueDate)]
//    ) var upcomingTransactions: [RecurringTransaction]
//
//    @Query(
//        filter: RecurringTransaction.transactionTypeFilter(type: .credit)
//        ,sort: [SortDescriptor(\RecurringTransaction.nextDueDate)]
//    ) var paydayTransactions: [RecurringTransaction] = []
//
//    //@State private var viewModel: ViewModel = ViewModel()
//
//    var body: some View {
//        Text("Depracated")
////        VStack {
////            HStack {
////                VStack {
////                    List(accountList) { account in
////                        Dashboard_AccountViewItem(acctData: account)
////                            .onTapGesture {
////                                router.navigateTo(
////                                    route: .transaction_List(account: account))
////                            }
////                    }
////                    Spacer()
////                }
////                Spacer()
////
////                VStack {
////                    List {
////                        Section(header: Text("Reserved Transactions")) {
////                            ForEach(reservedTransactions) { reserved in
////                                Dashboard_TransactionViewItem(transaction: reserved)
////                            }
////                        }
////                    }
////                    List {
////                        Section(header: Text("Pending Transactions")) {
////                            ForEach(pendingTransactions) { pending in
////                                Dashboard_TransactionViewItem(transaction: pending)
////                            }
////                        }
////                    }
////                    Spacer()
////                }
////                .frame(width: 200)
////
////                Spacer()
////                VStack {
////                    List {
////                        Section(header: Text("Payday")) {
////                            HStack {
////                                Spacer()
////                                Button {
////                                    if viewModel.selectedPaydays.count > 0 {
////                                        viewModel.isConfirmReservePaydayModalShowing.toggle()
////                                    }
////                                } label: {
////                                    Text("Paid")
////                                }
////                                .opacity(1)
////                            }
////
////                            ForEach(paydayTransactions, id: \.self) { payday in
////                                Dashboard_RecurringViewItem(recurringItem: payday, isSelected: viewModel.selectedPaydays.contains(payday)) {
////                                    if viewModel.selectedPaydays.contains(payday) {
////                                        viewModel.selectedPaydays.removeAll(where: { $0 == payday })
////                                    } else {
////                                        viewModel.selectedPaydays.append(payday)
////                                    }
////                                }
////                            }
////                        }
////                    }
////                    List {
////                        Section(header: Text("Upcoming Recurring Transactions")) {
////                            HStack {
////                                Spacer()
////                                Button {
////                                    if viewModel.selectedUpcomingTransactions.count > 0 {
////                                        viewModel.isConfirmReserveBillsModalShowing.toggle()
////                                    }
////                                } label: {
////                                    Text("Reserve")
////                                }
////                                .opacity(1)
////                            }
////
////                            ForEach(upcomingTransactions, id: \.self) { upcoming in
////                                Dashboard_RecurringViewItem(recurringItem: upcoming, isSelected: viewModel.selectedUpcomingTransactions.contains(upcoming)) {
////                                    if viewModel.selectedUpcomingTransactions.contains(upcoming) {
////                                        viewModel.selectedUpcomingTransactions.removeAll(where: { $0 == upcoming })
////                                    } else {
////                                        viewModel.selectedUpcomingTransactions.append(upcoming)
////                                    }
////                                }
////                            }
////                        }
////                    }
////
////                    Spacer()
////                }
////                .frame(width: 400)
////            }
////        }
////        .sheet(isPresented: $viewModel.isConfirmReservePaydayModalShowing, onDismiss: {viewModel.reservePaydayDismiss(modelContext: modelContext)}) {
////            if !$viewModel.selectedPaydays.isEmpty {
////                Dashboard_ReserveTransactionsModalView(
////                    reserveList: viewModel.selectedPaydays,
////                    selectedAccount: $viewModel.selectedAccount,
////                    didCancel: $viewModel.didCancel
////                )
////            }
////
////        }
////        .sheet(isPresented: $viewModel.isConfirmReserveBillsModalShowing, onDismiss: {viewModel.reserveBillsDismiss(modelContext: modelContext)}) {
////            if !$viewModel.selectedUpcomingTransactions.isEmpty {
////                Dashboard_ReserveTransactionsModalView(
////                    reserveList: viewModel.selectedUpcomingTransactions,
////                    selectedAccount: $viewModel.selectedAccount,
////                    didCancel: $viewModel.didCancel)
////            }
////        }
//    }
//}
//
////#Preview {
//    let p = Previewer()
//    DashboardViewz()
//        .modelContainer(p.container)
//        .environment(PathStore())
//        #if os(macOS)
//            .frame(width: 900, height: 500)
//        #endif
//}
