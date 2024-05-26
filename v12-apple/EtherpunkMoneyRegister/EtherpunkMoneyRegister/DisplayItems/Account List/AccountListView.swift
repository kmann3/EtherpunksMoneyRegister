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
    @State private var searchText = ""
    @State private var path = NavigationPath()
    @State private var isShowingDeleteActions = false
    @State private var accountToDelete: Account? = nil
    
    @State private var newAccount: Account = Account(name: "", startingBalance: 0)
    
    @Query(sort: [SortDescriptor(\Account.sortIndex, order: .forward), SortDescriptor(\Account.name, order: .forward)])
    var items: [Account]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(items) { item in
                    NavigationLink(value: NavData(navView: .TransactionList, account: item, transaction: nil)) {
                        AccountListItemView(account: item)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button {
                            addNewTransaction(account: item, transactionType: .debit)
                        } label: {
                            Label("New Debit", systemImage: "creditcard")
                        }
                        .tint(.cyan)
            
                        Button {
                            addNewTransaction(account: item, transactionType: .credit)
                        } label: {
                            Label("New Credit", systemImage: "banknote")
                        }
                        .tint(.indigo)
            
                        Button(role: .destructive) {
                            accountToDelete = item
                            isShowingDeleteActions = true
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
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
                if item.navView == .EditAccount && item.account != nil {
                    EditAccountView(path: $path, account: item.account!)
                        .navigationTitle("New Account")
                        .onDisappear {
                            print("back \(item.account!.name)")
                        }
                } else if item.navView == .TransactionList && item.account != nil {
                    TransactionListView(account: item.account!)
                } else if item.navView == .EditTransaction && item.transaction != nil {
                    EditTransactionDetailView(transaction: item.transaction!)
                } else if item.navView == .TransactionDetail && item.transaction != nil {
                    TransactionDetailView(transaction: item.transaction!)
                }
            }
            .navigationTitle("Account List")
        }

    }
    
    func createAccount() {
        modelContext.insert(newAccount)
        path.append(NavData(navView: .EditAccount, account: newAccount))
    }
    
    func deleteAccount(account: Account) {
        modelContext.delete(account)
    }
    
    func editAccount(account: Account) {
        print(account.createdOn)        
    }
    
    func addNewTransaction(account: Account, transactionType: TransactionType) {
        print("New \(transactionType) for: \(account.name)")
        let newTransaction: AccountTransaction = AccountTransaction(name: "", transactionType: transactionType, amount: 0, balance: account.currentBalance, pending: nil, cleared: nil, account: account)
        modelContext.insert(newTransaction)
        path.append(NavData(navView: .EditTransaction, transaction: newTransaction))
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
