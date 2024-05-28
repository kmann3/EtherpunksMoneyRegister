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
    @State private var path = NavigationPath()
    @State private var searchText = ""
    @Query var transactions: [AccountTransaction]
    
    var account: Account

    var body: some View {
        NavigationLink(value: NavData(navView: .editAccount, account: account)) {
            AccountListItemView(account: account)
        }
        // Should I use a lazyvstack?
        List(transactions) { item in
            NavigationLink(value: NavData(navView: .transactionDetail, transaction: item)) {
                TransactionListItemView(item: TransactionListItem(transaction: item))
            }
        }
        .toolbar {
            Button {
                createNewTransaction()
            } label: {
                Image(systemName: "plus")
            }
        }
        .searchable(text: $searchText)
//        .navigationDestination(for: Account.self) { item in
//            EditAccountView(path: $path, account: item)
//        }
    }
    
    init(account: Account) {
        self.account = account
        let accountId = account.id
        
        let sortOrder = [SortDescriptor(\AccountTransaction.createdOn, order: .reverse)]
        
        _transactions = Query(filter: #Predicate<AccountTransaction> { transaction in
            transaction.account.persistentModelID == accountId || transaction.account.name.localizedStandardContains("Amegy")
        }, sort: sortOrder)
    }
    
    func createNewTransaction() {
        print("Make new transactioin")
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionListView(account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
