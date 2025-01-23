//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//

import SwiftUI

struct DashboardView: View {
    @State var viewModel = ViewModel()

    var body: some View {
        #if os(macOS)
        VStack {
            HStack {
                VStack {
                    Text("Primary overview")
                    Dashboard_FullSummaryView(accounts: viewModel.accounts)
                        .padding(5)
                        .frame(minWidth: 200)

                    List(viewModel.accounts) { account in
                        Dashboard_AccountItemView(acctData: account)
                            .onTapGesture {
                                viewModel.pathStore.navigateTo(
                                    route: .transaction_List(account: account))
                            }
                            .frame(minWidth: 200)
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
                                        viewModel.pathStore.navigateTo(route: .transaction_Edit(transaction: reserved))
                                    }
                            }
                        }
                    }
                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(viewModel.pendingTransactions) { pending in
                                Dashboard_TransactionItemView(transaction: pending)
                                    .onTapGesture {
                                        viewModel.pathStore.navigateTo(route: .transaction_Edit(transaction: pending))
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
                                        viewModel.pathStore.navigateTo(route: .recurringTransaction_Edit(recTrans: creditItem))
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
                                                viewModel.pathStore
                                                    .navigateTo(route: .recurringGroup_Edit(recGroup: group))
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
                                        viewModel.pathStore.navigateTo(route: .recurringTransaction_Edit(recTrans: debitItem))
                                    }, label: { Label("Edit: \(debitItem.name)", systemImage: "icon") })
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 500)
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
    DashboardView(viewModel: DashboardView.ViewModel(dataSource: ds))
#if os(macOS)
        .frame(minWidth: 1000, minHeight: 750)
#endif
}
