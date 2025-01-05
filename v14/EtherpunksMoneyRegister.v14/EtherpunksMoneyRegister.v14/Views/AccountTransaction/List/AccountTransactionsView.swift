//
//  AccountTransactions.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftData
import SwiftUI

struct AccountTransactionsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(PathStore.self) var router

    @State var viewModel: ViewModel = ViewModel(account: Account())

    init(account: Account) {
        viewModel.account = account
    }

    var body: some View {
        List {
            Section(header: Text("Account Details")) {
                AccountListItemView(acctData: viewModel.account)
                    .onTapGesture {
                        router
                            .navigateTo(
                                route: .account_Details(
                                    account: viewModel.account))
                    }
                    .contextMenu(menuItems: {
                        Button {
                            router.navigateTo(
                                route: .account_Edit(account: viewModel.account)
                            )
                        } label: {
                            Label("Edit Account", systemImage: "pencil")
                        }
                    })
            }
            .padding(.top)

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(viewModel.accountTransactions, id: \.id) { t in
                    TransactionListItemView(transaction: t)
                        .onAppear {
                            debugPrint("Fetching transactions")
                            viewModel.fetchAccountTransactionsIfNecessary(
                                transaction: t, modelContext: modelContext)
                        }
                        .onTapGesture {
                            router.navigateTo(
                                route: .transaction_Detail(transaction: t))
                        }
                        .contextMenu(menuItems: {
                            Button {
                                // Mark as pending
                            } label: {
                                Label(
                                    "Mark Pending",
                                    systemImage: "arrowshape.turn.up.forward")
                            }
                            .disabled(t.transactionStatus == .pending || t.transactionStatus == .cleared || t.transactionStatus == .recurring)

                            Button {
                                // Mark as pending
                            } label: {
                                Label(
                                    "Mark Cleared",
                                    systemImage: "checkmark.circle")
                            }
                            .disabled(t.transactionStatus == .cleared || t.transactionStatus == .recurring)

                            Button {
                                viewModel.selectedTransaction = t
                                viewModel.isDeleteWarningPresented.toggle()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        })
                    // context menu for setting pending and cleared
                }
            }
        }
        .confirmationDialog(
            "Delete Confirmation",
            isPresented: $viewModel.isDeleteWarningPresented
        ) {
            Button("Yes") {
                viewModel.deleteTransaction(modelContext: modelContext)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                "Are you sure you want to delete \(viewModel.selectedTransaction?.name ?? "none_selected")"
            )
        }
        .navigationTitle("\(viewModel.account.name) - Transactions")
        .onAppear {
            viewModel.performAccountTransactionFetch(modelContext: modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section(header: Text("New Transaction")) {
                        Button {
                            print("New Debit")
                            //createNewTransaction(transactionType: .debit)
                        } label: {
                            Label("Debit / Expense", systemImage: "creditcard")
                        }
                        Button {
                            print("New Credit")
                            //createNewTransaction(transactionType: .credit)
                        } label: {
                            Label(
                                "Credit / Income / Deposit",
                                systemImage: "banknote")
                        }
                    }

                    Divider()

                    Section(header: Text("Actions")) {
                        Button("Mark Account as Balanced") {
                            //balanceAccount()
                            print("Mark account as balanced")
                        }
                    }

                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
    }
}

#Preview {
    let p = Previewer()
    AccountTransactionsView(account: p.bankAccount)
        .modelContainer(p.container)
        .environment(PathStore())
        #if os(macOS)
            .frame(width: 900, height: 500)
        #endif
}
