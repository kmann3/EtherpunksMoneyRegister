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
                        ZStack {
                            self.viewModel.selectedRecurringTransaction?.id == recTran.id ? Color.blue.opacity(0.3) : Color.clear
                            Text(recTran.name)
                        }

                        ZStack {
                            self.viewModel.selectedRecurringTransaction?.id == recTran.id ? Color.blue.opacity(0.3) : Color.clear
                            Text(recTran.amount.toDisplayString())
                        }

                        ZStack {
                            self.viewModel.selectedRecurringTransaction?.id == recTran.id ? Color.blue.opacity(0.3) : Color.clear
                            Text(recTran.nextDueDate.toSummaryDateMMMDEEE())
                        }

                        ZStack {
                            self.viewModel.selectedRecurringTransaction?.id == recTran.id ? Color.blue.opacity(0.3) : Color.clear
                            Text(recTran.recurringGroup?.name ?? "")
                        }
                    }

                    .onTapGesture {
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
    RecurringTransactionListView(selectedRecurringTransaction: MoneyDataSource.shared.previewer.discordRecurringTransaction) { action in debugPrint(action)}
}
