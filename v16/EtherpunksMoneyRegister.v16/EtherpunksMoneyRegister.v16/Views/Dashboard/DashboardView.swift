//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

import SwiftUI

struct DashboardView: View {
    @State var viewModel = ViewModel()
    @State private var selectedReserveGroup: RecurringGroup? = nil
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
                        Button {
#if DEBUG
                                    print("View: Dashboard | [Account] button press (\(account.name))")
#endif
                            handler(PathStore.Route.transaction_List(account: account))
                        } label: {
                            Dashboard_AccountItemView(acctData: account)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
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
                                Button {
#if DEBUG
                                            print("View: Dashboard | [Reserved] button press (\(reserved.name))")
#endif
                                       handler(PathStore.Route.transaction_Edit(transaction: reserved))
                                } label: {
                                    Dashboard_TransactionItemView(transaction: reserved)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .border(.gray)

                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(viewModel.pendingTransactions) { pending in
                               Button {
#if DEBUG
                                            print("View: Dashboard | [Pending] button press (\(pending.name))")
#endif
                                    handler(PathStore.Route.transaction_Edit(transaction: pending))
                             } label: {
                                 Dashboard_TransactionItemView(transaction: pending)
                                     .frame(maxWidth: .infinity, alignment: .leading)
                                     .contentShape(Rectangle())
                             }
                             .buttonStyle(.plain)
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
#if DEBUG
                                            print("View: Dashboard | [Recurring Credit] button press (\(creditItem.name))")
#endif
                                    handler(PathStore.Route.recurringTransaction_Reserve(recTran: creditItem))
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
#if DEBUG
                                            print("View: Dashboard | [Recurring Group] button press (\(group.name))")
#endif
                                        selectedReserveGroup = group
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
#if DEBUG
                                            print("View: Dashboard | [Recurring Debit] button press (\(debitItem.name))")
#endif
                                    handler(PathStore.Route.recurringTransaction_Reserve(recTran: debitItem))
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
        .sheet(item: $selectedReserveGroup, onDismiss: {
        }) { group in
            ReserveGroupView(group) { returnedQueue in
                if returnedQueue.count == 0 {
                    selectedReserveGroup = nil
                    return
                }
        #if DEBUG
                // TODO: Need to decide where the user might want to go after this usually
                print("ReserveGroupView returned: \(returnedQueue)")
        #endif
                selectedReserveGroup = nil
            }
            .frame(minWidth: 500, minHeight: 400)
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

