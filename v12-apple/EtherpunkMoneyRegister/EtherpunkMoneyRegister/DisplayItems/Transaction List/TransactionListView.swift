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
    @State var accountTransactions: [AccountTransaction] = []
    @State private var isLoading = false
    @State private var hasMoreTransactions = true
    @State private var currentAccountTransactionPage = 0
    @State private var currentSearchPage = 0
    @State private var transactionsPerPage = 10

    @State private var searchTransactionsResult: [AccountTransaction] = []

    @Bindable var account: Account

    init(path: Binding<NavigationPath>, accountToLoad: Account) {
        self._path = path
        self.account = accountToLoad
    }
    
    var body: some View {
        // Should I use a LazyVStack?
        List {
            Section(header: Text("Account Details")) {
                NavigationLink(value: NavData(navView: .accountEditor, account: account)) {
                    AccountListItemView(account: account)
                }
            }
            
            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(accountTransactions) { transaction in
                    NavigationLink(value: NavData(navView: .transactionDetail, transaction: transaction)) {
                        TransactionListItemView(transaction: transaction)
                            .onAppear {
                                fetchAccountTransactionsIfNecessary(transaction: transaction)
                            }
                    }
                }
            }
        }
        .onAppear {
            performAccountTransactionFetch()
        }
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
        .navigationTitle("\(account.name)")
        .searchable(text: $searchText) {
            List {
                Section(header: Text("Results (\(searchTransactionsResult.count))")) {
                    ForEach(searchTransactionsResult) { transaction in
                        NavigationLink(value: NavData(navView: .transactionDetail, transaction: transaction)) {
                            TransactionListItemView(transaction: transaction)
                        }
                    }
                }
            }
            .frame(minHeight: 400)
        }
        .onSubmit(of: .search) {
            performSearchTransactionFetch()
        }
    }

    func createNewTransaction(transactionType: TransactionType) {
        let transaction = AccountTransaction(account: account, transactionType: transactionType)
        path.append(NavData(navView: .transactionCreator, transaction: transaction))
    }

    private func performAccountTransactionFetch(currentPage: Int = 0) {
        let accountId: UUID = self.account.id

        // TODO: Remove this test UUID
        let testUUID = UUID(uuidString: "12345678-1234-1234-1234-123456789abc")
        let predicate = #Predicate<AccountTransaction> { transaction in
            if transaction.accountId == accountId || transaction.accountId == testUUID! {
                return true
            } else {
                return false
            }
        }

        var fetchDescriptor = FetchDescriptor<AccountTransaction>(predicate: predicate)
        fetchDescriptor.fetchLimit = transactionsPerPage
        fetchDescriptor.fetchOffset = self.currentAccountTransactionPage * transactionsPerPage
        fetchDescriptor.sortBy = [.init(\.createdOn, order: .reverse)]

        guard !isLoading && hasMoreTransactions else { return }
        isLoading = true
        DispatchQueue.global().async {
                do {
                    let newTransactions = try modelContext.fetch(fetchDescriptor)
                    DispatchQueue.main.async {
                        accountTransactions.append(contentsOf: newTransactions)
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

    private func fetchAccountTransactionsIfNecessary(transaction: AccountTransaction) {
        if let lastTransaction = accountTransactions.last, lastTransaction == transaction {
            currentAccountTransactionPage += 1
            performAccountTransactionFetch()
        }
    }

    private func performSearchTransactionFetch() {
        let accountId: UUID = self.account.id

        // TODO: Remove this test UUID
        // TODO: Add ability to search for amounts. For some reason it REALLY doesn't like doing that.
        let testUUID = UUID(uuidString: "12345678-1234-1234-1234-123456789abc")
        let predicate = #Predicate<AccountTransaction> { transaction in
            if (transaction.accountId == accountId || transaction.accountId == testUUID!) &&
                (transaction.name.localizedStandardContains(searchText) ||
                 transaction.notes.localizedStandardContains(searchText) ||
                 transaction.confirmationNumber.localizedStandardContains(searchText)
            ) {
                return true
            } else {
                return false
            }
        }

        var fetchDescriptor = FetchDescriptor<AccountTransaction>(predicate: predicate)
        fetchDescriptor.sortBy = [.init(\.createdOn, order: .reverse)]

        guard !isLoading && hasMoreTransactions else { return }
        isLoading = true
        DispatchQueue.global().async {
                do {
                    let newTransactions = try modelContext.fetch(fetchDescriptor)
                    DispatchQueue.main.async {
                        searchTransactionsResult = newTransactions
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

    private func fetchSearchTransactionsIfNecessary(transaction: AccountTransaction) {
        if let lastTransaction = searchTransactionsResult.last, lastTransaction == transaction {
            currentSearchPage += 1
            performSearchTransactionFetch()
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionListView(path: .constant(NavigationPath()), accountToLoad: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
