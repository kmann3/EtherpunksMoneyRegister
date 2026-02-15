//
//  AccountTransactionListView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/14/26.
//

import SwiftUI

struct AccountTransactionListView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ account: Account? = nil, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(account: account)
        self.handler = handler
    }

    var body: some View {
        VStack {
            if self.viewModel.account != nil {
                List {
                    Section(header: Text("Account Details")) {
                        VStack {
                            Button {
#if DEBUG
                                    print("View: Account Transaction | [Account] button press (\(self.viewModel.account!.name))")
#endif
                                handler(PathStore.Route.account_Details(account: self.viewModel.account!))
                            } label: {
                                AccountItemView(acctData: self.viewModel.account!)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            Text("Click above for account details.")
                                .font(Font.footnote)
                        }
                    }
                    Section(header: Text("Transactions"), footer: Text(self.viewModel.endOfListText)) {
                        ForEach(self.viewModel.accountTransactions, id: \.id) { tran in
                            Button {
#if DEBUG
                                    print("View: Account Transaction | [Transaction] button press (\(tran.name))")
#endif
                                handler(PathStore.Route.transaction_Detail(transaction: tran))
                            } label: {
                                TransactionListItemView(transaction: tran)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .frame(width: 400)
    }
}

#Preview {
    AccountTransactionListView(MoneyDataSource.shared.previewer.bankAccount) { action in print(action) }
}

#Preview {
    AccountTransactionListView { action in print(action) }
}
