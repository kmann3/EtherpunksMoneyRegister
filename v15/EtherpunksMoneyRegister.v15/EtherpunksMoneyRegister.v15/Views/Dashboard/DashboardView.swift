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

                    List(viewModel.accounts) { account in
                            Dashboard_AccountItemView(acctData: account)

                            .onTapGesture {
                                handler(PathStore.Route.transaction_List(account: account))
                            }

                    }
                    Spacer()
                }
                .frame(minWidth: 300, maxWidth: 300)
                Spacer()

                VStack {
                    List {
                        Section(header: Text("Reserved Transactions")) {
                            ForEach(viewModel.reservedTransactions) { reserved in
                                Dashboard_TransactionItemView(transaction: reserved)
                                    .onTapGesture {
                                        handler(PathStore.Route.transaction_Detail(transaction: reserved))
                                    }
                            }
                        }
                    }
                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(viewModel.pendingTransactions) { pending in
                                Dashboard_TransactionItemView(transaction: pending)
                                    .onTapGesture {
                                        handler(PathStore.Route.transaction_Detail(transaction: pending))
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
                                        handler(PathStore.Route.recurringTransaction_Reserve(recTran: creditItem))
                                }
                                .contextMenu {
                                    Button(action: {
                                        handler(PathStore.Route.recurringTransaction_Edit(recTran: creditItem))
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
                                            handler(PathStore.Route.recurringGroup_Reserve(recGroup: group))
                                        }
                                        .contextMenu {
                                            Button(action: {
                                                handler(PathStore.Route.recurringGroup_Edit(recGroup: group))
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
                                    handler(PathStore.Route.recurringTransaction_Reserve(recTran: debitItem))
                                }
                                .contextMenu {
                                    Button(action: {
                                        handler(PathStore.Route.recurringTransaction_Edit(recTran: debitItem))
                                    }, label: { Label("Edit: \(debitItem.name)", systemImage: "icon") })
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 300)
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
    DashboardView(viewModel: DashboardView.ViewModel(), handler: { _ in })
#if os(macOS)
        .frame(minWidth: 1000, minHeight: 750)
#endif
}
