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
            HStack {
                Text("Transaction Type: \(self.viewModel.recTran.transactionType)")
                Spacer()
            }

            HStack {
                Text("Default Account: \(self.viewModel.recTran.defaultAccount.name)")
                Spacer()
            }


            HStack {
                Text("Is Tax Related: \(self.viewModel.recTran.isTaxRelated ? "Yes" : "No")")
                Spacer()
            }

            HStack {
                Text("Next Due Date: \(self.viewModel.recTran.nextDueDate?.toSummaryDateMMMDY() ?? "unknown")")
                Spacer()
            }

            HStack {
                Text("Frequency: ")
                Spacer()
            }

            HStack {
                Text("Transaction Count: ")
                Spacer()
            }

            HStack {
                Text("Group: \(self.viewModel.recTran.recurringGroup?.name ?? "none")")
                Spacer()
            }
            
            HStack {
                Text("Notes: \(self.viewModel.recTran.notes)")
                Spacer()
            }

            HStack {
                Text("Created On: \(self.viewModel.recTran.createdOnUTC.toDebugDate())")
                Spacer()
            }

        }
            .frame(minWidth: 300)
    }
}

#Preview {
    RecurringTransactionDetailView(recTran: MoneyDataSource.shared.previewer.discordRecurringTransaction) { action in }
}
