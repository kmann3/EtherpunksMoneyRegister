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
                }
                .font(.headline)
                Divider()

                ForEach(self.viewModel.recurringTransactions, id: \.id) { tran in
                    GridRow {
                        Text(tran.name)
                        Text(tran.amount.toDisplayString())
                        Text(tran.nextDueDate.toSummaryDateMMMDEEE())
                    }
                    .background(self.viewModel.selectedRecurringTransaction?.id == tran.id ? Color.blue.opacity(0.3) : Color.clear)

                    .padding(.horizontal, 2)

                    .onTapGesture { t in
                        handler(PathStore.Route.recurringTransaction_Details(recTrans: tran))
                    }
                    Divider()
                }
            }
            .overlay(Rectangle().stroke(Color.gray, lineWidth: 1)) // Outer border
        }
    }
}

#Preview {
    RecurringTransactionListView() { action in }
}
