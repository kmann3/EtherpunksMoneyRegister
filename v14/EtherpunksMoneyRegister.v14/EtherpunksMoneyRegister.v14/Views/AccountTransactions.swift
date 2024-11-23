//
//  AccountTransactions.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct AccountTransactions: View {
    @State private var showOtherView = false
    var account: Account
    var transactions: [AccountTransaction] = []

    init(account: Account) {
        self.account = account
        let p = Previewer()
        transactions.insert(p.cvsTransaction, at: 0)
        transactions.insert(p.cvsTransaction, at: 0)
        transactions.insert(p.cvsTransaction, at: 0)
    }

    var body: some View {
        List {
            Section(header: Text("Account Details")) {
//                NavigationLink(
//                    destination: AccountDetailsView(
//                        account: account,
//                        presenting: showOtherView
//                    )
//                ) {
//                    AccountListItemView(acctData: account)
//                }
                //----
//                NavigationLink(destination: AccountDetailsView(account: account)) {
//                    AccountListItemView(acctData: account)
//                }
                //----
                NavigationStack {
                    AccountListItemView(acctData: account)
                        .navigationDestination(
                            isPresented: $showOtherView,
                            destination: {AccountDetailsView(
                                account: account,
                                presenting: $showOtherView
                            )}
                        )
                }
            }

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                // Options for grouping, outstanding first or by breated on?
                ForEach(transactions) { row in
                    NavigationLink(
                        destination: TransactionDetailView(transactionItem: row)
                    )
                    {
                        TransactionListItemView(transaction: row)
                    }

//                            .onAppear {
//                                fetchAccountTransactionsIfNecessary(transaction: transaction)
//                            }
                    }
                }
            }
        }    
}

#Preview {
    AccountTransactions(account: Previewer.bankAccount)
}
