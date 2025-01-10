//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import SwiftUI

struct DashboardView: View {
    @State var viewModel = ViewModel()

    var body: some View {
        VStack {
            HStack {
                VStack {
                    List(viewModel.accounts) { account in
                        Dashboard_AccountItemView(acctData: account)
                            .onTapGesture {
                                viewModel.pathStore.navigateTo(
                                    route: .transaction_List(account: account))
                            }
                    }
                    Spacer()
                }
                Spacer()

                VStack {
                    List {
                        Section(header: Text("Reserved Transactions")) {
                            ForEach(viewModel.reservedTransactions) { reserved in
                                Dashboard_TransactionItemView(transaction: reserved)
                            }
                        }
                    }
                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(viewModel.pendingTransactions) { pending in
                                Dashboard_TransactionItemView(transaction: pending)
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
                                    if viewModel.selectedCreditRecurringTransactions.count > 0 {
                                        viewModel.isConfirmReserveCreditDialogShowing.toggle()
                                    }
                                } label: {
                                    Text("Paid")
                                }
                                .opacity(1)
                            }

                            ForEach(viewModel.upcomingCreditRecurringTransactions, id: \.self) { creditItem in
                                Dashboard_RecurringItemView(recurringItem: creditItem, isSelected: viewModel.selectedCreditRecurringTransactions.contains(creditItem)) {
                                    if viewModel.selectedCreditRecurringTransactions.contains(creditItem) {
                                        viewModel.selectedCreditRecurringTransactions.removeAll(where: { $0 == creditItem })
                                    } else {
                                        viewModel.selectedCreditRecurringTransactions.append(creditItem)
                                    }
                                }
                            }
                        }
                    }
                    List {
                        Section(header: Text("Upcoming Recurring Transactions")) {
                            HStack {
                                Spacer()
                                Button {
                                    if viewModel.selectedDebitRecurringTransactions.count > 0 {
                                        viewModel.isConfirmReserveDebitDialogShowing.toggle()
                                    }
                                } label: {
                                    Text("Reserve")
                                }
                                .opacity(1)
                            }

                            ForEach(viewModel.upcomingDebitRecurringTransactions, id: \.self) { debitItem in
                                Dashboard_RecurringItemView(
                                    recurringItem: debitItem,
                                    isSelected: viewModel.selectedDebitRecurringTransactions.contains(debitItem)
                                ) {
                                    if viewModel.selectedDebitRecurringTransactions.contains(debitItem) {
                                        viewModel.selectedDebitRecurringTransactions.removeAll(where: { $0 == debitItem })
                                    } else {
                                        viewModel.selectedDebitRecurringTransactions.append(debitItem)
                                    }
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .frame(width: 400)
            }
        }
        .sheet(isPresented: $viewModel.isConfirmReserveCreditDialogShowing, onDismiss: {viewModel.reserveReserveDialogDismiss(transactionType: .credit)}) {
            if !$viewModel.selectedCreditRecurringTransactions.isEmpty {
                Dashboard_ReserveTransactionsDialogView(
                    reserveList: viewModel.selectedCreditRecurringTransactions,
                    selectedAccount: $viewModel.selectedAccountFromReserveDialog,
                    didCancel: $viewModel.didCancelReserveDialog
                )
            }

        }
        .sheet(isPresented: $viewModel.isConfirmReserveDebitDialogShowing, onDismiss: {viewModel.reserveReserveDialogDismiss(transactionType: .debit)}) {
            if !$viewModel.selectedDebitRecurringTransactions.isEmpty {
                Dashboard_ReserveTransactionsDialogView(
                    reserveList: viewModel.selectedDebitRecurringTransactions,
                    selectedAccount: $viewModel.selectedAccountFromReserveDialog,
                    didCancel: $viewModel.didCancelReserveDialog
                )
            }
        }
    }
}

#Preview {
    let ds = MoneyDataSource()
    DashboardView(viewModel: DashboardView.ViewModel(dataSource: ds))
#if os(macOS)
        .frame(width: 900, height: 500)
#endif
}
