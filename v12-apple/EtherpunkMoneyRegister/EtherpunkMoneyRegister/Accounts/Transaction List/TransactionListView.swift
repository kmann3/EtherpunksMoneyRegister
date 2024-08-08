//
//  TransactionListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//
import SwiftData
import SwiftUI
import Foundation

struct TransactionListView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var container: AppStateContainer
    @Binding private var path: NavigationPath

    @State private var searchText = ""
    @State var accountTransactions: [AccountTransaction] = []
    @State private var isLoading = false
    @State private var hasMoreTransactions = true
    @State private var currentAccountTransactionPage = 0
    @State private var currentSearchPage = 0
    @State private var transactionsPerPage = 10

    @State private var searchTransactionsResult: [AccountTransaction] = []

    @Bindable var account: Account

    init(accountToLoad: Account, path: Binding<NavigationPath>) {
        self.account = accountToLoad
        self._path = path
        //print(container.loadedSqliteDbPath)
    }
    
    var body: some View {
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
                    Section(header: Text("New Transaction")) {
                        Button {
                            print(container.loadedSqliteDbPath)
                            //createNewTransaction(transactionType: .debit)
                        } label: {
                            Label("Debit / Expense", systemImage: "creditcard")
                        }
                        Button {
                            createNewTransaction(transactionType: .credit)
                        } label: {
                            Label("Credit / Income / Deposit", systemImage: "banknote")
                        }
                    }

                    Divider()

                    Section(header: Text("Actions")) {
                        Button("Mark Account as Balanced"){
                            balanceAccount()
                        }
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
            // TODO: For some reason this does not take up the full screen like it should and I have no idea what a reasonable value looks like so 400 seems like a good start.
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

    func balanceAccount() {
        // TODO: Should we keep a history of when accounts are balanced? So a user can roll back?
        let accountId: UUID = self.account.id

        // TODO: Remove this test UUID
        let testUUID = UUID(uuidString: "12345678-1234-1234-1234-123456789abc")
        let predicate = #Predicate<AccountTransaction> { transaction in
            if (transaction.accountId == accountId || transaction.accountId == testUUID!) && transaction.pending == nil {
                return true
            } else {
                return false
            }
        }

        let fetchDescriptor = FetchDescriptor<AccountTransaction>(predicate: predicate)
        guard !isLoading && hasMoreTransactions else { return }
        isLoading = true
        let now = Date()
        DispatchQueue.global().async {
                do {
                    let newTransactions = try modelContext.fetch(fetchDescriptor)
                    for transaction in newTransactions {
                        transaction.balancedOn = now
                    }
                    account.lastBalanced = Date()
                    try! modelContext.save()
                    currentAccountTransactionPage = 0
                    accountTransactions = []
                    isLoading = false
                    performAccountTransactionFetch()
                } catch {
                    DispatchQueue.main.async {
                        print("Error fetching transactions: \(error.localizedDescription)")
                        isLoading = false
                    }
                }
        }
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

        var isAmount = false
        var amountToSearchPositive: Decimal = 0
        var amountToSearchNegative: Decimal = 0
        if let amount = Decimal(string: searchText) {
            isAmount = true
            amountToSearchNegative = -abs(amount)
            amountToSearchPositive = abs(amount)
        }

        // TODO: Remove this test UUID
        let testUUID = UUID(uuidString: "12345678-1234-1234-1234-123456789abc")
        let predicate = #Predicate<AccountTransaction> { transaction in
            if (transaction.accountId == accountId || transaction.accountId == testUUID!) &&
                (transaction.name.localizedStandardContains(searchText) ||
                 transaction.notes.localizedStandardContains(searchText) ||
                 transaction.confirmationNumber.localizedStandardContains(searchText) ||
                 (isAmount == true && (transaction.amount == amountToSearchNegative) || (transaction.amount == amountToSearchPositive))
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
        
        return TransactionListView(accountToLoad: previewer.cuAccount, path: .constant(NavigationPath()))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
