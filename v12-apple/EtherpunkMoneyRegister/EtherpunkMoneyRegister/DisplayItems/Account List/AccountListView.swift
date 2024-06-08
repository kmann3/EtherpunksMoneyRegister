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
    
    @Query(sort: [SortDescriptor(\Tag.name, order: .forward)])
    var availableTags: [Tag]
    
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // TODO: Link to all outstanding items
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
                
                switch(item.navView) {
                    
                case .accountCreator:
                    EditAccountDetailsView(path: $path, doSave: $doSave, account: item.account!)
                        .onDisappear {
                            if(doSave == true) {
                                modelContext.insert(item.account!)
                            }
                        }
                case .accountEditor:
                    EditAccountDetailsView(path: $path, doSave: $doSave, account: item.account!)
                        .onDisappear {
                            if(doSave == true) {
                                //save account
                                try? modelContext.save()
                            }
                        }

                case .accountList:
                    Text("That is this view. We should never reach here.")
                    
                case.recurringTransactionDetail:
                    Text("Recurring Transaction Detail")
                case .recurringTransactionEditor:
                    Text("Recurring Transaction Editor")
                case .recurringTransactionList:
                    Text("Recurring Transaction List")
                    
                case.recurringTransactionGroupDetail:
                    Text("Recurring Transaction Group Detail")
                case.recurringTransactionGroupEditor:
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
                    TransactionListView(path: $path, account: item.account!)
                }
            }
            .navigationTitle("Account List")
        }

    }
    
    func createAccount() {
        let newAccount = Account(name: "", startingBalance: 0)
        path.append(NavData(navView: .accountCreator, account: newAccount))
    }
    
    func deleteAccount(account: Account) {
        modelContext.delete(account)
    }
    
    func addNewTransaction(account: Account, transactionType: TransactionType) {
        print("New \(transactionType) for: \(account.name)")
        let newTransaction: AccountTransaction = AccountTransaction(name: "", transactionType: transactionType, amount: 0, balance: account.currentBalance, pending: nil, cleared: nil, account: account)
        modelContext.insert(newTransaction)
        path.append(NavData(navView: .transactionEditor, transaction: newTransaction))
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
