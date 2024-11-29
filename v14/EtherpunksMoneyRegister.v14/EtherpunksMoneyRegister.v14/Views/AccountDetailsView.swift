//
//  AccountDetailsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/23/24.
//

import SwiftUI

struct AccountDetailsView: View {
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
    AccountDetailsView(account: Previewer.bankAccount)
}
