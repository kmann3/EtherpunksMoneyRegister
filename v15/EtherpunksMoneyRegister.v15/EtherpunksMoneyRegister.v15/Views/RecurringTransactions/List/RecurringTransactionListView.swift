//
//  RecurringTransactionListView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/29/25.
//

import SwiftUI

struct RecurringTransactionListView: View {
    var viewModel = ViewModel()
    var handler: (PathStore.Route) -> Void

    init(selectedRecurringTransaction: RecurringTransaction? = nil, _ handler: @escaping (PathStore.Route) -> Void) {
        viewModel = ViewModel(selectedRecurringTransaction: selectedRecurringTransaction)
        self.handler = handler
    }

    var body: some View {
        List {
            HStack {
                Text("Recurring Transactions")
                    .bold(true)
                    .font(.title)
                Spacer()
                Button {
                    handler(PathStore.Route.recurringTransaction_Create)
                } label: {
                    Text("+")
                }
            }
            Grid {
                GridRow {
                    Text("Name")
                    Text("Amount")
                    Text("Next due")
                    Text("Group")
                }
                .font(.headline)
                Divider()

                ForEach(self.viewModel.recurringTransactions, id: \.id) { recTran in
                    GridRow {
                        Text(recTran.name)
                        Text(recTran.amount.toDisplayString())
                        Text(recTran.nextDueDate.toSummaryDateMMMDEEE())
                        Text(recTran.recurringGroup?.name ?? "")
                    }
                    .background(self.viewModel.selectedRecurringTransaction?.id == recTran.id ? Color.blue.opacity(0.3) : Color.clear)

                    .padding(.horizontal, 2)

                    .onTapGesture { t in
                        handler(PathStore.Route.recurringTransaction_Details(recTran: recTran))
                    }
                    Divider()
                }
            }
        }
        .frame(minWidth: 400)
    }
}

#Preview {
    RecurringTransactionListView() { action in }
}
