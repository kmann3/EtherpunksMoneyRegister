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
    @Query(sort: [SortDescriptor(\Account.sortIndex, order: .forward), SortDescriptor(\Account.name, order: .forward)])
    var items: [Account]
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach(items) { item in
                    AccountListItemView(item: item)
                        .navigationDestination(for: Account.self) { account in
                            TransactionListView(account: item)
                        }
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button {
                        print("Edit")
                    } label: {
                        Label("Edit", systemImage: "gear")
                    }
                    .tint(.indigo)
                    
                    Button(role: .destructive) {
                        print("Delete")
                    } label: {
                        Label("Delete", systemImage: "trash.fill")
                    }
                }
                .listRowSeparator(.hidden)
                
            }
            .listStyle(.plain)
            .toolbar {
                Button {
                    print("Create new account")
                } label: {
                    Image(systemName: "plus")
                }
            }
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
