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
                            ForEach(viewModel.upcomingCreditRecurringTransactions, id: \.self) { creditItem in
                                Dashboard_RecurringItemView(
                                    recurringItem: creditItem) {
                                        viewModel.selectedCreditRecurringTransaction = creditItem
                                        viewModel.isConfirmDepositCreditDialogShowing.toggle()
//                                        viewModel.selectedCreditRecurringTransactions.append(creditItem)
//                                        viewModel.returnAmount = creditItem.amount
//                                        viewModel.selectedDate = Date()
//                                        viewModel.isCleared = true
//                                        viewModel.isConfirmReserveCreditDialogShowing.toggle()
                                }
                            }
                        }
                    }

                    List {
                        Section(header: Text("Recurring Debits")) {
                            ForEach(viewModel.upcomingRecurringGroups, id: \.self) { group in
                                HStack {
                                    Spacer()

                                    Dashboard_RecurringGroupView(
                                        recurringGroup: group) {
                                            // TODO: Implement
                                        }

                                    Spacer()
                                }

                            }

                            ForEach(viewModel.upcomingNonGroupDebitRecurringTransactions, id: \.self) { debitItem in
                                Dashboard_RecurringItemView(
                                    recurringItem: debitItem
                                ) {
                                    // TODO: Implement
                                }
                            }
                        }
                    }

                    Spacer()
                }
                .frame(width: 400)
            }
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
        .frame(width: 900, height: 600)
#endif
}
