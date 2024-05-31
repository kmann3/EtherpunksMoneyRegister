//
//  TransactionListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//
import SwiftData
import SwiftUI

struct TransactionListView: View {
    
    //@Environment(\.modelContext) var modelContext
    @Binding private var path: NavigationPath
    @State private var searchText = ""
    @Query var transactions: [AccountTransaction]
    
    @Bindable var account: Account

    init(path: Binding<NavigationPath>, account: Account) {
        self._path = path
        self.account = account
        let accountId = account.id
        
        let sortOrder = [SortDescriptor(\AccountTransaction.createdOn, order: .reverse)]
        
        _transactions = Query(filter: #Predicate<AccountTransaction> { transaction in
            transaction.account.persistentModelID == accountId || transaction.account.name.localizedStandardContains("Amegy")
        }, sort: sortOrder)
    }
    
    var body: some View {

        List {
            Section {
                NavigationLink(value: NavData(navView: .editAccount, account: account)) {
                    AccountListItemView(account: account)
                }

            }
            
            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(transactions) { item in
                    NavigationLink(value: NavData(navView: .transactionDetail, transaction: item)) {
                        TransactionListItemView(item: TransactionListItem(transaction: item))
                    }
                }
            }
        }
        // Should I use a lazyvstack?
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
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
                    
                    Divider()
                    
                    Button {
                        //
                    } label: {
                        Label("Created On", systemImage: "calendar")
                    }
                    Button {
                        //
                    } label: {
                        Label("Reserved and pending first", systemImage: "calendar.badge.exclamationmark")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("\(account.name)")
    }

    
    func createNewTransaction(transactionType: TransactionType) {
        let transaction = AccountTransaction(name: "", transactionType: transactionType, amount: 0, balance: account.currentBalance, pending: Date(), cleared: nil, account: account)
        path.append(NavData(navView: .createTransaction, transaction: transaction))
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionListView(path: .constant(NavigationPath()), account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
