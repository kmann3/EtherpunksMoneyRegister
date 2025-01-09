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

    @Query(sort: [SortDescriptor(\AccountTransaction.createdOnUTC, order: .reverse)])
    var accountTransactions: [AccountTransaction]

    @Query(sort: [SortDescriptor(\Account.name)]) var accountDetails: [Account]

    init(account: Account) {
        viewModel = ViewModel(account: account)
        viewModel.modelContext = modelContext
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
                ForEach(accountTransactions, id: \.id) { t in
                    TransactionListItemView(transaction: t)
                        .onTapGesture {
                            router.navigateTo(
                                route: .transaction_Detail(transaction: t))
                        }
                        .contextMenu(menuItems: {
                            Button {
                                viewModel.markTransactionAsPending(transaction: t, modelContext: modelContext)
                            } label: {
                                Label(
                                    "Mark Pending",
                                    systemImage: "arrowshape.turn.up.forward")
                            }
                            .disabled(t.transactionStatus == .pending || t.transactionStatus == .cleared || t.transactionStatus == .recurring)

                            Button {
                                viewModel.markTransactionAsCleared(transaction: t, modelContext: modelContext)
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
    AccountTransactionsView(account: Previewer().bankAccount)
        .modelContainer(Previewer().container)
        .environment(PathStore())
        #if os(macOS)
            .frame(width: 900, height: 500)
        #endif
}
