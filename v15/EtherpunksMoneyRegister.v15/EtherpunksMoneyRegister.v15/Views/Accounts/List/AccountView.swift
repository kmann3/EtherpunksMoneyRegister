//
//  AccountView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//

import SwiftUI

struct AccountView: View {
    @State var viewModel = ViewModel()
    @State private var selectedAccount: Account? = nil

    init(accountToLoad: Account? = nil) {
        if accountToLoad != nil {
            selectedAccount = accountToLoad!
            debugPrint("Loaded account: \(accountToLoad!.name)")
        }
    }

    var body: some View {
        NavigationSplitView {
            List(viewModel.accounts, id: \.id, selection: $selectedAccount) { account in
                NavigationLink(value: account) {
                    Text(account.name)
                }
//                        AccountItemView(acctData: account)
//                            .onTapGesture {
//                                viewModel.pathStore.navigateTo(
//                                    route: .transaction_List(account: account))
//                            }
//                            .contextMenu {
//                                Button(action: {
//                                    viewModel.pathStore
//                                        .navigateTo(route: .account_Edit(account: account))
//                                }, label: { Label("Edit: \(account.name)", systemImage: "pencil") })
//                            }
                    }
        } content: {
            if let selectedAccount {
                // List transactions
                Text("Transactions for \(selectedAccount.name)")
            } else {
                Text("Select an account")
            }
        } detail: {
            Text("Select a transaction")
        }


    }
}

#Preview {
    AccountView()
}
