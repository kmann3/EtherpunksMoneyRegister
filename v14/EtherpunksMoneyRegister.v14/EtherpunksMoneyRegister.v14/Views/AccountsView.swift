//
//  AccountsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI
import SwiftData

struct AccountsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Account.name, comparator: .localizedStandard)])
    var accountList: [Account]

    var body: some View {
        List(accountList) { account in
            NavigationLink(destination: AccountTransactionsView(account: account)) {
                AccountListItemView(acctData: account)
            }
            .navigationTitle(account.name)
        }
    }
}

#Preview {
    let p = Previewer()
    AccountsView()
        .modelContainer(p.container)
}
