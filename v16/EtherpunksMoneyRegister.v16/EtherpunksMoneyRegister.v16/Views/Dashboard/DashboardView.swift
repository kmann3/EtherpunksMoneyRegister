//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

import SwiftUI
#if os(macOS)
import AppKit
import SwiftData
#endif

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
                    .accessibilityIdentifier("ReservedTransactionsList")
                    .border(.gray)

                    List {
                        Section(header: Text("Pending Transactions")) {
                            ForEach(viewModel.pendingTransactions) { pending in
                             Button {
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
                    .accessibilityIdentifier("PendingTransactionsList")
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
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-UITestBridge") {
                Button("Dump Counts") {
                    do {
                        // Query SwiftData for all AccountTransaction records
                        let ctx = MoneyDataSource.shared.modelContext
                        let all = try ctx.fetch(FetchDescriptor<AccountTransaction>())
                        let payload: [String: Any] = ["allTransactions": all.count]
                        let data = try JSONSerialization.data(withJSONObject: payload)
                        if let str = String(data: data, encoding: .utf8) {
                            #if os(macOS)
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(str, forType: .string)
                            #endif
                        }
                    } catch {
                        print("UITestBridge dump failed: \(error)")
                    }
                }
                .accessibilityIdentifier("UITest_DumpCounts")
                .padding(4)
            }
            #endif
        }
        .sheet(item: $selectedReserveGroup, onDismiss: {
        }) { group in
            ReserveGroupView(group) { returnedQueue in
                if returnedQueue.count == 0 {
                    selectedReserveGroup = nil
                    return
                }

                selectedReserveGroup = nil
                if(self.viewModel.userPrefs.afterReserveGoTo != .dashboard) {
                    // TODO: Implement code for sending them
                    // Most likely either want to go to account transactionList or recurring group list?
                }
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

