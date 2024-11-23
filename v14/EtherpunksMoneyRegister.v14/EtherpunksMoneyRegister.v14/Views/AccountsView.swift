//
//  AccountsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct AccountsView: View {
    var accountList: [Account] = []

    init() {
        self.accountList.insert(Previewer.bankAccount, at: 0)
    }

    var body: some View {
        List {
            ForEach(accountList) { row in
                NavigationLink(destination: AccountTransactions(account: row)) {
                    AccountListItemView(acctData: row)
                }
            }
        }
        .navigationTitle(MenuOptionsEnum.accounts.title)
    }
}

#Preview {
    AccountsView()
}
