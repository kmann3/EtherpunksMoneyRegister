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
        #if os(macOS)
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
                        Section(header: Text("Recurring Credit")) {
                            HStack {
                                Spacer()
                                Button {
                                    if viewModel.selectedCreditRecurringTransactions.count > 0 {
                                        viewModel.isConfirmReserveCreditDialogShowing.toggle()
                                    }
                                } label: {
                                    Text("Deposit")
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
                        Section(header: Text("Recurring Debits")) {
                            ForEach(viewModel.upcomingRecurringGroups, id: \.self) { group in
                                Dashboard_RecurringGroupView(
                                    recurringGroup: group,
                                    isSelected: viewModel.selectedDebitGroups.contains(group),
                                    action: {
                                        if viewModel.selectedDebitGroups.contains(group) {
                                            viewModel.selectedDebitGroups.removeAll(where: { $0 == group })
                                        } else {
                                            viewModel.selectedDebitGroups.append(group)
                                        }
                                })
                                .onTapGesture {
                                    viewModel.selectedDebitGroups.removeAll()
                                    viewModel.selectedDebitGroups.append(group)
                                    viewModel.isConfirmReserveDebitDialogShowing.toggle()
                                }
                                .frame(alignment: .center)
                            }

                            ForEach(viewModel.upcomingNonGroupDebitRecurringTransactions, id: \.self) { debitItem in
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
                    reserveGroups: [],
                    reserveTransactions: viewModel.selectedDebitRecurringTransactions,
                    selectedAccount: $viewModel.selectedAccountFromReserveDialog,
                    didCancel: $viewModel.didCancelReserveDialog
                )
            }

        }
        .sheet(isPresented: $viewModel.isConfirmReserveDebitDialogShowing, onDismiss: {viewModel.reserveReserveDialogDismiss(transactionType: .debit)}) {
            if !$viewModel.selectedDebitRecurringTransactions.isEmpty {
                Dashboard_ReserveTransactionsDialogView(
                    reserveGroups: viewModel.selectedDebitGroups,
                    reserveTransactions: viewModel.selectedDebitRecurringTransactions,
                    selectedAccount: $viewModel.selectedAccountFromReserveDialog,
                    didCancel: $viewModel.didCancelReserveDialog
                )
            }
        }
        #endif
#if os(iOS)
        VStack {
            VStack {
                List {
                    Section(header: Text("Accounts")) {
                        ForEach(viewModel.accounts) { account in
                            Dashboard_AccountItemView(acctData: account)
                                .onTapGesture {
                                    viewModel.pathStore.navigateTo(
                                        route: .transaction_List(account: account))
                                }
                        }
                    }

                    Section(header: Text("Reserved Transactions")) {
                        ForEach(viewModel.reservedTransactions) { reserved in
                            Dashboard_TransactionItemView(transaction: reserved)
                        }
                    }

                    Section(header: Text("Pending Transactions")) {
                        ForEach(viewModel.pendingTransactions) { pending in
                            Dashboard_TransactionItemView(transaction: pending)
                        }
                    }

                    Section(header: Text("Recurring Credit")) {
                        HStack {
                            Spacer()
                            Button("Deposit") {
                                if viewModel.selectedCreditRecurringTransactions.count > 0 {
                                    viewModel.isConfirmReserveCreditDialogShowing.toggle()
                                }
                            }
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

                    Section(header: Text("Recurring Debits")) {
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
            }
        }
#endif
    }
}

#Preview {
    let ds = MoneyDataSource()
    DashboardView(viewModel: DashboardView.ViewModel(dataSource: ds))
#if os(macOS)
        .frame(width: 900, height: 600)
#endif
}
