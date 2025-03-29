//
//  RecurringTransactionDetailView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/29/25.
//

import SwiftUI

struct RecurringTransactionDetailView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(recTran: RecurringTransaction, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(recTran: recTran)
        self.handler = handler
    }

    var body: some View {
        List {
            HStack {
                Text("Name: \(self.viewModel.recTran.name)")
                Spacer()
                Button("Edit Transaction") {
                    handler(PathStore.Route.recurringTransaction_Edit(recTran: self.viewModel.recTran))
                }
            }
        }
            .frame(minWidth: 300)
    }
}

#Preview {
    RecurringTransactionDetailView(recTran: MoneyDataSource.shared.previewer.discordRecurringTransaction) { action in }
}
