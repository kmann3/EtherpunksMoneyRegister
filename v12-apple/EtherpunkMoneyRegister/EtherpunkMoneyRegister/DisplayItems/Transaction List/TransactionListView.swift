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
    @State private var searchText = ""
    @Query var transactions: [AccountTransaction]
    
    var account: Account

    var body: some View {
        NavigationStack() {
            AccountListItemView(item: account)
            List(transactions) { item in
                    TransactionListItemView(item: TransactionListItem(transaction: item))
            }
            .toolbar {
                Button {
                    createNewTransaction()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .searchable(text: $searchText)
        }
    }
    
    init(account: Account) {
        self.account = account
        let accountId = account.id
        
        let sortOrder = [SortDescriptor(\AccountTransaction.createdOn, order: .reverse)]
        
        _transactions = Query(filter: #Predicate<AccountTransaction> { transaction in
            transaction.account.id == accountId ||
            transaction.account.name.localizedStandardContains("Amegy")
        }, sort: sortOrder)
    }
    
    func createNewTransaction() {
        print("Make new transactioin")
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionListView(account: Account(name: "Amegy Bank", startingBalance: 238.99))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
