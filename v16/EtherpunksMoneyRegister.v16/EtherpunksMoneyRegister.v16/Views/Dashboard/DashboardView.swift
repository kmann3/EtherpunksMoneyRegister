//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
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
                .border(.gray)

                Spacer()

                VStack {
                    List {
                        Section(header: Text("Reserved Transactions")) {
                            ForEach(viewModel.reservedTransactions) { reserved in
                                Dashboard_TransactionItemView(transaction: reserved) {

                                }
                                .onTapGesture {
                                    handler(PathStore.Route.transaction_Edit(transaction: reserved))
                                }
                                .contextMenu {
                                    Button(
                                        action: {
                                            handler(PathStore.Route.transaction_Edit(transaction: reserved))
                                        },
                                        label: { Label("Edit: \(reserved.name)", systemImage: "icon") }
                                    )
                                }
                            }
                        }
                    }
                    .border(.gray)

                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(viewModel.pendingTransactions) { pending in
                                Dashboard_TransactionItemView(transaction: pending)
                                {
                                    
                                }
                                .onTapGesture {
                                    handler(PathStore.Route.transaction_Edit(transaction: pending))
                                }
                                .contextMenu {
                                    Button(
                                        action: {
                                            handler(PathStore.Route.transaction_Edit(transaction: pending))
                                        },
                                        label: { Label("Edit: \(pending.name)", systemImage: "pencil") }
                                    )
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 300)
                .border(.gray)

                Spacer()
                VStack {
                    List {
                        Section(header: Text("Recurring Credit")) {
                            ForEach(
                                viewModel.upcomingCreditRecurringTransactions.sorted(by: { $0.nextDueDate ?? Date() < $1.nextDueDate ?? Date() }),
                                id: \.self
                            ) { creditItem in
                                Dashboard_RecurringItemView(
                                    recurringItem: creditItem
                                ) {
                                    handler(PathStore.Route.recurringTransaction_Reserve(recTran: creditItem))
                                }
                                .contextMenu {
                                    Button(
                                        action: {
                                            handler(PathStore.Route.recurringTransaction_Edit(recTran: creditItem))
                                        },
                                        label: { Label("Edit: \(creditItem.name)", systemImage: "pencil") }
                                    )
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                    .border(.gray)

                    List {
                        Section(header: Text("Recurring Debits")) {
                            ForEach(viewModel.upcomingRecurringGroups, id: \.self) { group in
                                HStack {
                                    Spacer()
                                    Dashboard_RecurringGroupView(
                                        recurringGroup: group
                                    ) {
                                        handler(PathStore.Route.recurringGroup_Reserve(recGroup: group))
                                    }
                                    .contextMenu {
                                        Button(
                                            action: {
                                                handler(PathStore.Route.recurringGroup_Edit(recGroup: group))
                                            },
                                            label: { Label("Edit: \(group.name)", systemImage: "pencil") }
                                        )
                                    }

                                    Spacer()
                                }
                            }

                            ForEach(
                                viewModel.upcomingNonGroupDebitRecurringTransactions.sorted(by: {
                                    $0.nextDueDate ?? Date() < $1.nextDueDate ?? Date()
                                }),
                                id: \.self
                            ) { debitItem in
                                Dashboard_RecurringItemView(
                                    recurringItem: debitItem
                                ) {
                                    handler(PathStore.Route.recurringTransaction_Reserve(recTran: debitItem))
                                }
                                .contextMenu {
                                    Button(
                                        action: {
                                            handler(PathStore.Route.recurringTransaction_Edit(recTran: debitItem))
                                        },
                                        label: { Label("Edit: \(debitItem.name)", systemImage: "pencil") }
                                    )
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: 400)
                .border(.gray)
            }
        }
#endif
#if os(iOS)
    // TODO: Implement iOS Dashboard
    Text("iOS TBI")
#endif
    }
}

#Preview {
    DashboardView(viewModel: DashboardView.ViewModel(), handler: { _ in })
}
