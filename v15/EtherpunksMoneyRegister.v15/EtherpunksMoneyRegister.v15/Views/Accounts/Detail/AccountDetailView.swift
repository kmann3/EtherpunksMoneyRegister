//
//  AccountDetailView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 4/5/25.
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
                    Button("Edit Account") {
                        
                    }
                }
                Text("startingBalance: \(self.viewModel.account.startingBalance)")
                Text("currentBalance: \(self.viewModel.account.currentBalance)")
                Text("outstandingBalance: \(self.viewModel.account.outstandingBalance)")
                Text("outstandingItemCount: \(self.viewModel.account.outstandingItemCount)")
                Text("transactionCount: \(self.viewModel.account.transactionCount)")
            }

            Section("Misc") {
                Text("Id: \(self.viewModel.account.id)")
                Text("Created On: \(self.viewModel.account.createdOnUTC.toDebugDate())")
            }
        }
    }
}

#Preview {
    AccountDetailView(MoneyDataSource.shared.previewer.bankAccount) { action in print(action) }
}
