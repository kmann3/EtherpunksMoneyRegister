//
//  AccountDetailsView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//
// Summary:
//      This view lists transactions for an account. This will be the primary use of the application.

import SwiftUI

struct AccountTransactionListView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(account: Account?, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(account: account)
        self.handler = handler
    }

    var body: some View {
        VStack {
            if self.viewModel.account != nil {
                List {
                    Section(header: Text("Account Details")) {
                        AccountItemView(acctData: self.viewModel.account!)
                            .onTapGesture {
                                handler(PathStore.Route.account_Details(account: self.viewModel.account!))
                            }
                    }
                    Section(header: Text("Transactions"), footer: Text("End of list")) {
                        ForEach(self.viewModel.accountTransactions, id: \.id) { tran in
                            TransactionListItemView(transaction: tran)
                                .onTapGesture { t in
                                    handler(PathStore.Route.transaction_Detail(transaction: tran))
                                }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AccountTransactionListView(account: MoneyDataSource.shared.previewer.bankAccount) { _ in }
}

#Preview {
    AccountTransactionListView(account: nil) { _ in }
}
