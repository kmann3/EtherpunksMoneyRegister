//
//  AccountEditView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 4/5/25.
//

import SwiftUI

struct AccountEditView: View {
    @StateObject var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ account: Account = Account(), _ handler: @escaping (PathStore.Route) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(account))
        self.handler = handler
    }

    var body: some View {
        List {
            HStack {
                Spacer()
                Button("Save") {
                    self.viewModel.save()
                }
            }
            HStack {
                Text("Account Name:")
                TextField(text: self.$viewModel.name, prompt: Text("Required")) {
                    Text("Account name")
                }.padding(5)
            }

            HStack {
                Text("Starting Balance:")
                CurrencyFieldView(amount: $viewModel.startingBalance)
                    .padding(5)

            }

            HStack {
                Text("Notes:")
                TextField(text: self.$viewModel.notes) {
                    Text("Notes")
                }.padding(5)
            }
        }
        .frame(width: 450)
    }
}

#Preview {
    AccountEditView(MoneyDataSource.shared.previewer.bankAccount) { action in print(action) }
}
