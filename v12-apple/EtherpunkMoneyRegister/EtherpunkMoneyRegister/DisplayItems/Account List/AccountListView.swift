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
    
    @Query(sort: [SortDescriptor(\Account.sortIndex, order: .forward), SortDescriptor(\Account.name, order: .forward)])
    var items: [Account]
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach(items) { item in
                    NavigationLink(value: item) {
                        AccountListItemView(item: item)
                    }
                }
                .listRowSeparator(.hidden)
                .swipeActions(allowsFullSwipe: false) {
                    Button {
                        print("Edit")
                        //editAccount(account: item)
                    } label: {
                        Label("Edit", systemImage: "gear")
                    }
                    .tint(.indigo)
        
                    Button(role: .destructive) {
                        //deleteAccount(account: item)
                        print("Delete")
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
                
            }
            .listStyle(.plain)
            .toolbar {
                Button {
                    print("Add")
                    //createAccount()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .searchable(text: $searchText)
            .navigationDestination(for: Account.self){ item in
                TransactionListView(account: item)
            }
        }
        



    }
    
    func createAccount() {
        let newAccount = Account(name: "", startingBalance: 0)
        modelContext.insert(newAccount)
        //path.append(newAccount)
    }
    
    func deleteAccount(account: Account) {
        modelContext.delete(account)
    }
    
    func editAccount(account: Account) {
        print(account.createdOn)        
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
