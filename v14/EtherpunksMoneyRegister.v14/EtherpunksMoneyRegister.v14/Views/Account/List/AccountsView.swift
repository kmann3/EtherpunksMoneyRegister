//
//  AccountsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/10/25.
//

import SwiftUI

struct AccountsView: View {
    @State var viewModel = ViewModel()
    var body: some View {
        List(viewModel.accounts) { account in
            AccountListItemView(acctData: account)
                .onTapGesture {
                    viewModel.pathStore.navigateTo(
                        route: .transaction_List(account: account))
                }
            // add context menu for going to edit it
            // add long tap gesture for context menu too
        }
    }
}

#Preview {
    AccountsView()
}
