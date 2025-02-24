//
//  AccountDetailsView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//
// Summary:
//      This view lists transactions for an account. This will be the primary use of the application.

import SwiftUI

struct AccountTransactionsView: View {
    @State var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(account: Account, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(account: account)
        self.handler = handler
    }

    var body: some View {
        List {
            Section(header: Text("Account Details")) {
                AccountItemView(acctData: viewModel.account)
            }
            Section(header: Text("Transactions"), footer: Text("End of list")) {
                ForEach(viewModel.accountTransactions, id: \.id) { tran in
                        TransactionListItemView(transaction: tran)
                        .onTapGesture { t in
                            handler(PathStore.Route.transaction_Detail(transaction: tran))
                        }
                }
            }
        }
    }
}

#Preview {
    AccountTransactionsView(account: Previewer().bankAccount) { _ in }
}
