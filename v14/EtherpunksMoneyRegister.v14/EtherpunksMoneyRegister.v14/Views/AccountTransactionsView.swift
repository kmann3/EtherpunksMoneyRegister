//
//  AccountTransactions.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct AccountTransactionsView: View {
    @State private var searchText = ""

    var account: Account
    var transactions: [AccountTransaction] = []

    init(account: Account) {
        self.account = account
        let p = Previewer()
        transactions.insert(p.cvsTransaction, at: 0)
        transactions.insert(p.discordTransaction, at: 0)
        transactions.insert(p.huluPendingTransaction, at: 0)
        transactions.insert(p.verizonReservedTransaction, at: 0)
        transactions.insert(p.burgerKingTransaction, at: 2)
    }

    var body: some View {
        List {
            Section(header: Text("Account Details")) {
                NavigationLink(
                    destination: AccountDetailsView(account: account)
                ) {
                    AccountListItemView(acctData: account)
                }
            }

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                        ForEach(transactions, id: \.id) { index in
                            NavigationLink(
                                destination: TransactionDetailsView(
                                    transactionItem: index
                                )
                            ) {
                                TransactionListItemView(transaction: index)
                                    .onAppear {
                                        print("More loading?")
                                        //fetchAccountTransactionsIfNecessary(transaction: transaction)
                                    }
                            }
                        }
            }
        }
        .navigationTitle("\(account.name) - Transactions")
        .onAppear {
            //performAccountTransactionFetch()
        }
        .searchable(text: $searchText) {
//            List {
//                Section(header: Text("Results (\(searchTransactionsResult.count))")) {
//                    ForEach(searchTransactionsResult) { transaction in
//                        NavigationLink(value: NavData(navView: .transactionDetail, transaction: transaction)) {
//                            TransactionListItemView(transaction: transaction)
//                        }
//                    }
//                }
//            }
//            // TODO: For some reason this does not take up the full screen like it should and I have no idea what a reasonable value looks like so 400 seems like a good start.
//            .frame(minHeight: 400)
        }
        .onSubmit(of: .search) {
            //performSearchTransactionFetch()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Section(header: Text("New Transaction")) {
                        Button {
                            print("New Debit")
                            //createNewTransaction(transactionType: .debit)
                        } label: {
                            Label("Debit / Expense", systemImage: "creditcard")
                        }
                        Button {
                            print ("New Credit")
                            //createNewTransaction(transactionType: .credit)
                        } label: {
                            Label("Credit / Income / Deposit", systemImage: "banknote")
                        }
                    }

                    Divider()

                    Section(header: Text("Actions")) {
                        Button("Mark Account as Balanced"){
                            //balanceAccount()
                            print("Mark account as balanced")
                        }
                    }


                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
    }
}

#Preview {
    AccountTransactionsView(account: Previewer.bankAccount)
}
