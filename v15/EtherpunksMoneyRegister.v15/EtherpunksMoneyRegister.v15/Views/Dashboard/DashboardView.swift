//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//

import SwiftUI

struct DashboardView: View {
    @State var viewModel = ViewModel()
    var handler: (PathStore.Route) -> Void

    var body: some View {
        #if os(macOS)
        VStack {
            HStack {
                VStack {
                    Text("Primary overview")
                    Dashboard_FullSummaryView(accounts: viewModel.accounts)
                        .padding(5)
                        .frame(minWidth: 300)

                    List(viewModel.accounts) { account in
                            Dashboard_AccountItemView(acctData: account)

                            .onTapGesture {
                                let route = PathStore.Route.transaction_List(account: account)
                                handler(route)
                            }
                            .frame(minWidth: 300)
                    }
                    Spacer()
                }
                Spacer()

                VStack {
                    List {
                        Section(header: Text("Reserved Transactions")) {
                            ForEach(viewModel.reservedTransactions) { reserved in
                                Dashboard_TransactionItemView(transaction: reserved)
                                    .onTapGesture {
                                        let route = PathStore.Route.transaction_Detail(transaction: reserved)
                                        handler(route)
                                    }
                            }
                        }
                    }
                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(viewModel.pendingTransactions) { pending in
                                Dashboard_TransactionItemView(transaction: pending)
                                    .onTapGesture {
                                        let route = PathStore.Route.transaction_Detail(transaction: pending)
                                        handler(route)
                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 200)

                Spacer()
                VStack {
                    List {
                        Section(header: Text("Recurring Credit")) {
                            ForEach(viewModel.upcomingCreditRecurringTransactions.sorted(by: {$0.nextDueDate ?? Date() < $1.nextDueDate ?? Date()}), id: \.self) { creditItem in
                                Dashboard_RecurringItemView(
                                    recurringItem: creditItem) {
                                        viewModel.selectedCreditRecurringTransaction = creditItem
                                        viewModel.returnTransaction = AccountTransaction(recurringTransaction: creditItem)
                                        viewModel.isConfirmDepositCreditDialogShowing.toggle()
                                }
                                .contextMenu {
                                    Button(action: {
                                        let route = PathStore.Route.recurringTransaction_Edit(recTrans: creditItem)
                                        handler(route)
                                    }, label: { Label("Edit: \(creditItem.name)", systemImage: "icon") })
                                }
                            }
                        }
                    }
                    .frame(height: 200)

                    List {
                        Section(header: Text("Recurring Debits")) {
                            ForEach(viewModel.upcomingRecurringGroups, id: \.self) { group in
                                HStack {
                                    Spacer()

                                    Dashboard_RecurringGroupView(
                                        recurringGroup: group) {
                                            viewModel.selectedDebitGroup = group
                                            viewModel.returnTransactions = []
                                            group.recurringTransactions!.forEach { t in
                                                viewModel.returnTransactions.append(AccountTransaction(recurringTransaction: t))
                                            }

                                            viewModel.isConfirmReserveDebitGroupDialogShowing.toggle()
                                        }
                                        .contextMenu {
                                            Button(action: {
                                                let route = PathStore.Route.recurringGroup_Edit(recGroup: group)
                                                handler(route)
                                            }, label: { Label("Edit: \(group.name)", systemImage: "icon") })
                                        }

                                    Spacer()
                                }

                            }

                            ForEach(
                                viewModel.upcomingNonGroupDebitRecurringTransactions.sorted(by: {$0.nextDueDate ?? Date() < $1.nextDueDate ?? Date()}),
                                id: \.self
                            ) { debitItem in
                                Dashboard_RecurringItemView(
                                    recurringItem: debitItem
                                ) {
                                    viewModel.selectedDebitRecurringTransaction = debitItem
                                    viewModel.returnTransaction = AccountTransaction(recurringTransaction: debitItem)
                                    viewModel.isConfirmReserveDebitTransactionDialogShowing.toggle()
                                }
                                .contextMenu {
                                    Button(action: {
                                        let route = PathStore.Route.recurringTransaction_Edit(recTrans: debitItem)
                                        handler(route)
                                    }, label: { Label("Edit: \(debitItem.name)", systemImage: "icon") })
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 400)
            }
        }
        .sheet(isPresented: $viewModel.isConfirmDepositCreditDialogShowing, onDismiss: {viewModel.reserveDepositCreditDialogDismiss()}) {
            Dashboard_ReserveTransactionsDepositCreditDialogView(
                reserveTransaction: viewModel.selectedCreditRecurringTransaction,
                returnTransaction: $viewModel.returnTransaction,
                didCancel: $viewModel.didCancelReserveDialog
            )
        }
        .sheet(isPresented: $viewModel.isConfirmReserveDebitGroupDialogShowing, onDismiss: {viewModel.reserveDepositDebitGroupDialogDismiss()}) {
            Dashboard_ReserveDebitGroupDialogView(
                reserveGroup: viewModel.selectedDebitGroup,
                returnTransactions: $viewModel.returnTransactions,
                didCancel: $viewModel.didCancelReserveDialog
            )
        }
        .sheet(
            isPresented: $viewModel.isConfirmReserveDebitTransactionDialogShowing,
            onDismiss: {viewModel.reserveDepositDebitTransactionDialogDismiss()
            }) {
                Dashboard_ReserveDebitTransactionDialogView(
                reserveTransaction: viewModel.selectedDebitRecurringTransaction,
                returnTransaction: $viewModel.returnTransaction,
                didCancel: $viewModel.didCancelReserveDialog
            )
        }
        #endif


        #if os(iOS)
        // TODO: Implement
        Text("iOS TBI")
        #endif
    }
}

#Preview {
    let ds = MoneyDataSource()
    DashboardView(viewModel: DashboardView.ViewModel(dataSource: ds), handler: { _ in })
#if os(macOS)
        .frame(minWidth: 1000, minHeight: 750)
#endif
}
