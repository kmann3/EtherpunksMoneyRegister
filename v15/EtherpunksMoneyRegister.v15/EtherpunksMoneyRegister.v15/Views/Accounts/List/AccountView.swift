//
//  AccountView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//

import SwiftUI

struct AccountView: View {
    @State var viewModel = ViewModel()
    
    var body: some View {
        List(viewModel.accounts) { account in
            AccountItemView(acctData: account)
                .onTapGesture {
                    viewModel.pathStore.navigateTo(
                        route: .transaction_List(account: account))
                }
                .contextMenu {
                    Button(action: {
                        viewModel.pathStore
                            .navigateTo(route: .account_Edit(account: account))
                    }, label: { Label("Edit: \(account.name)", systemImage: "pencil") })
                }
        }
    }
}

#Preview {
    AccountView()
}
