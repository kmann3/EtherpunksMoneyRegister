//
//  AccountDetailsView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//
// Summary:
//      This view lists transactions for an account. This will be the primary use of the application.

import SwiftUI

struct AccountDetailsView: View {
    @State var viewModel: ViewModel

    init(account: Account) {
        viewModel = ViewModel(account: account)
    }

    var body: some View {
        List {
            Section(header: Text("Account Details")) {
                AccountItemView(acctData: viewModel.account)
            }
            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(viewModel.accountTransactions, id: \.id) { tran in
                        TransactionListItemView(transaction: tran)
                }
            }
        }
    }
}

#Preview {
    AccountDetailsView(account: Previewer().bankAccount)
}
