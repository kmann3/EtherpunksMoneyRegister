//
//  AccountListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/19/24.
//
import SwiftData
import SwiftUI

struct AccountListView: View {
    @Environment(\.modelContext) var modelContext

    // TODO: Implement account search
    @State private var searchText = ""

    @State private var path = NavigationPath()
    @State private var isShowingDeleteActions = false
    @State private var accountToDelete: Account? = nil
    @State private var accounts: [Account] = []
    @State private var isLoading = false
    @State private var hasMoreAccounts = true
    @State private var currentPage = 0
    @State private var accountsPerPage = 10

    @Query(sort: [SortDescriptor(\Tag.name, order: .forward)])
    var availableTags: [Tag]

    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(accounts) { account in
                    NavigationLink(value: NavData(navView: .transactionList, account: account, transaction: nil)) {
                        AccountListItemView(account: account)
                            .onAppear {
                                fetchItemsIfNecessary(account: account)
                            }
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button {
                            addNewTransaction(account: account, transactionType: .debit)
                        } label: {
                            Label("New Debit", systemImage: "creditcard")
                        }
                        .tint(.cyan)

                        Button {
                            addNewTransaction(account: account, transactionType: .credit)
                        } label: {
                            Label("New Credit", systemImage: "banknote")
                        }
                        .tint(.indigo)

                        Button(role: .destructive) {
                            accountToDelete = account
                            isShowingDeleteActions = true
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }

                    if isLoading {
                        ProgressView()
                    }
                }
                Text("End of list")
            }
            .toolbar {
                Button {
                    createAccount()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .confirmationDialog("Delete account?", isPresented: $isShowingDeleteActions) {
                Button("Confirm Delete: \(accountToDelete?.name ?? "ERROR")", role: .destructive) {
                    if let item = accountToDelete {
                        deleteAccount(account: item)
                        isShowingDeleteActions = false
                        accountToDelete = nil
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationDestination(for: NavData.self) { item in

                switch item.navView {
                case .accountCreator:
                    Text("New Account")
                case .accountEditor:
                    Text("Edit Account")
                case .accountList:
                    Text("That is this view. We should never reach here.")
                case .accountDeletor:
                    Text("Delete account with transaction count > 0")

                case .recurringTransactionDetail:
                    Text("Recurring Transaction Detail")
                case .recurringTransactionEditor:
                    Text("Recurring Transaction Editor")
                case .recurringTransactionList:
                    Text("Recurring Transaction List")

                case .recurringTransactionGroupDetail:
                    Text("Recurring Transaction Group Detail")
                case .recurringTransactionGroupEditor:
                    Text("Recurring Transaction Group Editor")
                case .recurringTransactionGroupList:
                    Text("Recurring Transaction Group List")

                case .tagDetail:
                    TagDetailView(path: $path, tag: item.tag!)

                case .tagEditor:
                    Text("Tag Editor")

                case .transactionCreator:
                    EditTransactionDetailView(transaction: item.transaction!, availableTags: availableTags, path: $path)

                case .transactionDetail:
                    TransactionDetailView(path: $path, transaction: item.transaction!)

                case .transactionEditor:
                    EditTransactionDetailView(transaction: item.transaction!, availableTags: availableTags, path: $path)

                case .transactionList:
                    TransactionListView(path: $path, accountToLoad: item.account!)
                }
            }
            .onAppear {
                performFetch()
            }
            .navigationTitle("Account List")
            .listRowSeparator(.hidden)
        }
    }

    private func createAccount() {
        let newAccount = Account(name: "", startingBalance: 0)
        path.append(NavData(navView: .accountCreator, account: newAccount))
    }

    func deleteAccount(account: Account) {
        if(account.transactionCount > 0) {
            // TODO: Redirect them to let them know this is going to delete data they cannot get back
        } else {
            modelContext.delete(account)
            currentPage = 0
            accounts = []
            performFetch()
        }
    }

    private func addNewTransaction(account: Account, transactionType: TransactionType) {
        print("New \(transactionType) for: \(account.name)")
        let newTransaction = AccountTransaction(account: account, transactionType: transactionType)
        modelContext.insert(newTransaction)
        path.append(NavData(navView: .transactionEditor, transaction: newTransaction))
    }

    private func performFetch(currentPage: Int = 0) {
        var fetchDescriptor = FetchDescriptor<Account>()
        fetchDescriptor.fetchLimit = accountsPerPage
        fetchDescriptor.fetchOffset = self.currentPage * accountsPerPage
        fetchDescriptor.relationshipKeyPathsForPrefetching = [\Account.transactions]
        fetchDescriptor.sortBy = [
                .init(\.sortIndex, order: .forward),
                .init(\.name, order: .forward)
            ]

        guard !isLoading && hasMoreAccounts else { return }
        isLoading = true
        DispatchQueue.global().async {
                do {
                    let newAccounts = try modelContext.fetch(fetchDescriptor)
                    DispatchQueue.main.async {
                        accounts.append(contentsOf: newAccounts)
                        isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("Error fetching accounts: \(error.localizedDescription)")
                        isLoading = false
                    }
                }
            }
    }

    private func fetchItemsIfNecessary(account: Account) {
        if let lastAccount = accounts.last, lastAccount == account {
            currentPage += 1
            performFetch()
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return AccountListView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
