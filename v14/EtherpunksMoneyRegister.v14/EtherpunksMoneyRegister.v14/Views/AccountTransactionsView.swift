//
//  AccountTransactions.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct AccountTransactionsView: View {
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
                NavigationLink(
                    destination: AccountDetailsView(account: account)
                ) {
                    AccountListItemView(acctData: account)
                }
            }

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                VStack {
                    Text("Some transaction here")
                }
            }
        }
    }
}

#Preview {
    AccountTransactionsView(account: Previewer.bankAccount)
}
