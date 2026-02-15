//
//  AccountDetailView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/14/26.
//

import SwiftUI

struct AccountDetailView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ account: Account, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(account: account)
        self.handler = handler
    }

    var body: some View {
        List {
            Section("General Information") {
                HStack {
                    Text("Name: \(self.viewModel.account.name)")
                    Spacer()
                    Button("Edit Account") { handler(PathStore.Route.account_Edit(account: self.viewModel.account)) }
                }
                Text("Transaction Count: \(self.viewModel.account.transactionCount)")
                Text("Starting Balance: \(self.viewModel.account.startingBalance.toDisplayString())")
                Text("Current Balance: \(self.viewModel.account.currentBalance.toDisplayString())")
                Text("Outstanding Balance: \(self.viewModel.account.outstandingBalance.toDisplayString())")
                Text("Outstanding Item Count: \(self.viewModel.account.outstandingItemCount)")
            }

            Section("Misc") {
                Text("Id: \(self.viewModel.account.id)")
                Text("Created On: \(self.viewModel.account.createdOnUTC.toDebugDate())")
            }
        }
        .frame(width: 450)
    }
}

#Preview {
    AccountDetailView(MoneyDataSource.shared.previewer.bankAccount) { action in print(action) }
}
