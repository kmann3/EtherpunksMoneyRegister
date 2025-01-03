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
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var hasMoreTransactions = true
    @State private var currentAccountTransactionPage = 0
    @State private var currentSearchPage = 0
    @State private var transactionsPerPage = 10
    @State var accountTransactions: [AccountTransaction] = []

    @State var lastTransactions: [AccountTransaction] = []

    var account: Account

    init(account: Account) {
        self.account = account
    }

    var body: some View {
        List {
            Section(header: Text("Account Details")) {
                NavigationLink(
                    destination: AccountDetailsView(account: account)
                ) {
                    AccountListItemView(acctData: account)
                }
            }

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(accountTransactions, id: \.id) { index in
                    NavigationLink(destination: TransactionDetailsView(transactionItem: index)) {
                        TransactionListItemView(transaction: index)
                            .onAppear {
                                fetchAccountTransactionsIfNecessary(transaction: index)
                            }
                    }
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
}
