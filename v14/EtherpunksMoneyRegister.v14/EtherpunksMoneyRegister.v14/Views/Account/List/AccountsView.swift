//
//  AccountsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftData
import SwiftUI

struct AccountsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(PathStore.self) var router
    @Query(sort: [SortDescriptor(\Account.name, comparator: .localizedStandard)]) var accountList: [Account]

    var body: some View {
        List(accountList) { account in
            AccountListItemView(acctData: account)
                .onTapGesture {
                    router.navigateTo(
                        route: .transaction_List(account: account))
                }
            // add context menu for going to edit it
            // add long tap gesture for context menu too
        }
    }
}

#Preview {
    let p = Previewer()
    AccountsView()
        .modelContainer(p.container)
        .environment(PathStore())
}
