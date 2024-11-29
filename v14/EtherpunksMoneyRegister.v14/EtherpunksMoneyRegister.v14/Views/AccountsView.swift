//
//  AccountsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct AccountsView: View {
    @State private var showOtherView = false
    var accountList: [Account] = []

    init() {
        self.accountList.insert(Previewer.bankAccount, at: 0)
    }

    var body: some View {
        List(self.accountList) { account in
            NavigationLink(destination: AccountTransactionsView(account: account)) {
                AccountListItemView(acctData: account)
            }
            .navigationTitle(account.name)
        }
    }
}

#Preview {
    AccountsView()
}
