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
    @State private var doSave: Bool = false
    
    @Query(sort: [SortDescriptor(\Account.sortIndex, order: .forward), SortDescriptor(\Account.name, order: .forward)])
    var items: [Account]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(items) { item in
                    NavigationLink(value: NavData(navView: .transactionList, account: item, transaction: nil)) {
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
                if item.navView == .createAccount && item.account != nil {
                    
                    // CREATE NEW ACCOUNT
                    
                    EditAccountView(path: $path, doSave: $doSave, account: item.account!)
                        .onDisappear {
                            if(doSave == true) {
                                //save account
                                modelContext.insert(item.account!)
                            }
                        }
                } else if item.navView == .editAccount && item.account != nil {
                    
                    // EDIT ACCOUNT
                    
                    EditAccountView(path: $path, doSave: $doSave, account: item.account!)
                        .onDisappear {
                            if(doSave == true) {
                                //save account
                                try? modelContext.save()
                            }
                        }
                }else if item.navView == .transactionList && item.account != nil {
                    
                    // SHOW TRANSACTIONS FOR ACCOUNT
                    
                    TransactionListView(path: $path, account: item.account!)
                } else if item.navView == .createTransaction && item.transaction != nil {
                    
                    // CREATE TRANSACTION
                    
                    EditTransactionDetailView(path: $path, doSave: $doSave, transaction: item.transaction!)
                        .onDisappear {
                            if(doSave == true) {
                                // I think we need to add it to the context?
                                modelContext.insert(item.transaction!)
                                try? modelContext.save()
                            }
                        }
                } else if item.navView == .editTransaction && item.transaction != nil {
                    
                    // EDIT TRANSACTION
                    
                    EditTransactionDetailView(path: $path, doSave: $doSave, transaction: item.transaction!)
                        .onDisappear {
                            if(doSave == true) {
                                try? modelContext.save()
                            }
                        }
                } else if item.navView == .transactionDetail && item.transaction != nil {
                    
                    // SHOW TRANSACTION DETAILS
                    
                    TransactionDetailView(path: $path, transaction: item.transaction!)
                }
            }
            .navigationTitle("Account List")
        }

    }
    
    func createAccount() {
        let newAccount = Account(name: "", startingBalance: 0)
        path.append(NavData(navView: .createAccount, account: newAccount))
    }
    
    func deleteAccount(account: Account) {
        modelContext.delete(account)
    }
    
    func addNewTransaction(account: Account, transactionType: TransactionType) {
        print("New \(transactionType) for: \(account.name)")
        let newTransaction: AccountTransaction = AccountTransaction(name: "", transactionType: transactionType, amount: 0, balance: account.currentBalance, pending: nil, cleared: nil, account: account)
        modelContext.insert(newTransaction)
        path.append(NavData(navView: .editTransaction, transaction: newTransaction))
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
