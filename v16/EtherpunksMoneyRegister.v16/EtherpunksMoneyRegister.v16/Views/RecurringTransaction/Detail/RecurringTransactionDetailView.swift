//
//  AccountDetailView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/14/26.
//

import SwiftUI

struct RecurringTransactionDetailView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ recurringTransaction: RecurringTransaction, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(recurringTransaction: recurringTransaction)
        self.handler = handler
    }

    var body: some View {
        List {
            Section("General Information") {
                HStack {
                    Text("Name: \(self.viewModel.recurringTransaction.name)")
                    Spacer()
                    Button("Edit Recurring Transaction") { handler(PathStore.Route.recurringTransaction_Edit(recTran: self.viewModel.recurringTransaction)) }
                }
            }

            Section("Misc") {
                Text("Id: \(self.viewModel.recurringTransaction.id)")
                Text("Created On: \(self.viewModel.recurringTransaction.createdOnUTC.toDebugDate())")
            }
        }
        .frame(width: 450)
    }
}

#Preview {
    RecurringTransactionDetailView(MoneyDataSource.shared.previewer.discordRecurringTransaction) { action in DLog(action.description) }
}
