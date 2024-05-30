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
            } label: {
                Label("Add New", systemImage: "plus")
            }
        }
        .searchable(text: $searchText)
    }
    
    init(account: Account) {
        self.account = account
        let accountId = account.id
        
        let sortOrder = [SortDescriptor(\AccountTransaction.createdOn, order: .reverse)]
        
        _transactions = Query(filter: #Predicate<AccountTransaction> { transaction in
            transaction.account.persistentModelID == accountId || transaction.account.name.localizedStandardContains("Amegy")
        }, sort: sortOrder)
    }
    
    func createNewTransaction(transactionType: TransactionType) {
        let transaction = AccountTransaction(name: "", transactionType: transactionType, amount: 0, balance: account.currentBalance, pending: Date(), cleared: nil, account: account)
        path.append(NavData(navView: .createTransaction, transaction: transaction))
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
