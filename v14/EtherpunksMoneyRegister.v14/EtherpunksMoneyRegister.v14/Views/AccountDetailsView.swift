//
//  AccountDetailsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/23/24.
//

import SwiftUI

struct AccountDetailsView: View {
    @Environment(\.modelContext) var modelContext
    var account: Account

    init(account: Account) {
        self.account = account
    }

    var body: some View {
        VStack {
            Text("Account Details View")
        }
    }
}

#Preview {
    let p = Previewer()
    AccountDetailsView(account: p.bankAccount)
        .modelContainer(p.container)
}
