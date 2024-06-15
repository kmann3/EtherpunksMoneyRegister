//
//  TransactionListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//
import SwiftData
import SwiftUI

struct TransactionListView: View {
    @Environment(\.modelContext) var modelContext
    @Binding private var path: NavigationPath

    // TODO: Implement transaction search
    @State private var searchText = ""
    @State var transactions: [AccountTransaction] = []
    @State private var isLoading = false
    @State private var hasMoreTransactions = true
    @State private var currentPage = 0
    @State private var transactionsPerPage = 10

    @Bindable var account: Account

    init(path: Binding<NavigationPath>, account: Account) {
        self._path = path
        self.account = account
        //let accountId = account.id
        //let sortOrder = [SortDescriptor(\AccountTransaction.createdOn, order: .reverse)]
    }
    
    var body: some View {
        List {
            Section(header: Text("Account Details")) {
                NavigationLink(value: NavData(navView: .accountEditor, account: account)) {
                    AccountListItemView(account: account)
                }
            }
            
            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(transactions) { item in
                    NavigationLink(value: NavData(navView: .transactionDetail, transaction: item)) {
                        TransactionListItemView(transaction: item)
                            .onAppear {
                                fetchItemsIfNecessary(transaction: item)
                            }
                    }
                }
            }
        }
        .onAppear {
            performFetch()
        }
        // Should I use a lazyvstack?
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        createNewTransaction(transactionType: .debit)
                    } label: {
                        Label("Debit / Expense", systemImage: "creditcard")
                    }
                    Button {
                        createNewTransaction(transactionType: .credit)
                    } label: {
                        Label("Credit / Income / Deposit", systemImage: "banknote")
                    }
                    
                    Divider()
                    
                    Button {
                        //
                    } label: {
                        Label("Created On", systemImage: "calendar")
                    }
                    Button {
                        //
                    } label: {
                        Label("Reserved and pending first", systemImage: "calendar.badge.exclamationmark")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("\(account.name)")
    }

    func createNewTransaction(transactionType: TransactionType) {
        let transaction = AccountTransaction(account: account, transactionType: transactionType)
        path.append(NavData(navView: .transactionCreator, transaction: transaction))
    }

    private func performFetch(currentPage: Int = 0) {
        var fetchDescriptor = FetchDescriptor<AccountTransaction>()
        fetchDescriptor.fetchLimit = transactionsPerPage
        fetchDescriptor.fetchOffset = self.currentPage * transactionsPerPage
        fetchDescriptor.sortBy = [.init(\.createdOn, order: .reverse)]

        guard !isLoading && hasMoreTransactions else { return }
        isLoading = true
        DispatchQueue.global().async {
                do {
                    let newTransactions = try modelContext.fetch(fetchDescriptor)
                    DispatchQueue.main.async {
                        transactions.append(contentsOf: newTransactions)
                        isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error fetching transactions: \(error.localizedDescription)")
                        isLoading = false
                    }
                }
            }
    }

    private func fetchItemsIfNecessary(transaction: AccountTransaction) {
        if let lastTransaction = transactions.last, lastTransaction == transaction {
            currentPage += 1
            performFetch()
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionListView(path: .constant(NavigationPath()), account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
