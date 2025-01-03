//
//  AccountTransactions.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI
import SwiftData

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
                AccountListItemView(acctData: account)
                // add context menu for editing
                // long and short tap for context menu?
            }

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(accountTransactions, id: \.id) { t in
                    TransactionListItemView(transaction: t)
                        .onAppear {
                            fetchAccountTransactionsIfNecessary(transaction: t)
                        }
                        .onTapGesture {
                            router.navigateTo(route: .transaction_Detail(transaction: t))
                        }
                        .contextMenu(menuItems: {
                            Button {
                                // Mark as pending
                            } label: {
                                Label("Mark Pending", systemImage: "trash")
                            }

                            Button {
                                // Mark as pending
                            } label: {
                                Label("Mark Cleared", systemImage: "trash")
                            }

                            Button {
                                //viewModel.tagToDelete = transactionTag
                                //viewModel.isDeleteWarningPresented.toggle()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        })
                        // context menu for setting pending and cleared
                }
            }
        }
        .navigationTitle("\(account.name) - Transactions")
        .onAppear {
            performAccountTransactionFetch()
        }
        .searchable(text: $searchText) {
//            List {
//                Section(header: Text("Results (\(searchTransactionsResult.count))")) {
//                    ForEach(searchTransactionsResult) { transaction in
//                        NavigationLink(value: NavData(navView: .transactionDetail, transaction: transaction)) {
//                            TransactionListItemView(transaction: transaction)
//                        }
//                    }
//                }
//            }
//            // TODO: For some reason this does not take up the full screen like it should and I have no idea what a reasonable value looks like so 400 seems like a good start.
//            .frame(minHeight: 400)
        }
        .onSubmit(of: .search) {
            //performSearchTransactionFetch()
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
                            print ("New Credit")
                            //createNewTransaction(transactionType: .credit)
                        } label: {
                            Label("Credit / Income / Deposit", systemImage: "banknote")
                        }
                    }

                    Divider()

                    Section(header: Text("Actions")) {
                        Button("Mark Account as Balanced"){
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

    private func performAccountTransactionFetch(currentPage: Int = 0) {
        let accountId: UUID = self.account.id

        let predicate = #Predicate<AccountTransaction> { transaction in
            if transaction.accountId == accountId {
                return true
            } else {
                return false
            }
        }

        var fetchDescriptor = FetchDescriptor<AccountTransaction>(predicate: predicate)
        fetchDescriptor.fetchLimit = transactionsPerPage
        fetchDescriptor.fetchOffset = self.currentAccountTransactionPage * transactionsPerPage
        fetchDescriptor.sortBy = [.init(\.createdOnUTC, order: .reverse)]

        guard !isLoading && hasMoreTransactions else { return }
        isLoading = true
        DispatchQueue.global().async {
            do {
                let newTransactions = try modelContext.fetch(fetchDescriptor)
                DispatchQueue.main.async {
                    if lastTransactions == newTransactions {
                        hasMoreTransactions = false
                        isLoading = false
                        debugPrint("End of list")
                    } else {
                        accountTransactions.append(contentsOf: newTransactions)
                        lastTransactions = newTransactions
                        isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error fetching transactions: \(error.localizedDescription)")
                    isLoading = false
                }
            }
        }
    }

    private func fetchAccountTransactionsIfNecessary(transaction: AccountTransaction) {
        if let lastTransaction = accountTransactions.last, lastTransaction == transaction {
            debugPrint("More refresh")
            currentAccountTransactionPage += 1
            performAccountTransactionFetch()
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
