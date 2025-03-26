//
//  TagDetailView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/12/25.
//

import SwiftUI

struct TagDetailView: View {

    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(tag: TransactionTag, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(tag: tag)
        self.handler = handler
    }

    var body: some View {
        List {
            VStack {
                HStack {
                    Text("Tag info: \(self.viewModel.tag.name)")
                    Spacer()
                }
                HStack {
                    if self.viewModel.lastUsed != nil {
                        Text("Last Used: ")
                        Text(
                            self.viewModel.lastUsed!,
                            format: .dateTime.year().month().day())
                    } else {
                        Text("Last Used: never")
                    }
                    Spacer()
                }

                HStack {
                    Text("Usage count: \(self.viewModel.itemCount)")
                    Spacer()
                }
            }
            Section(header: Text("Recurring"), footer: Text("End of list")) {
                Grid() {
                    GridRow {
                        Text("Name")
                        Text("Default Account")
                        Text("Next Due Date")
                        Text("Amount")
                    }
                    .font(.headline)

                    ForEach(self.viewModel.recurringTransactions, id: \.id) { rtran in
                        GridRow {
                            Text("\(rtran.name)")
                            Text(rtran.defaultAccount.name)
                            if rtran.nextDueDate != nil {
                                Text(
                                    rtran.nextDueDate!,
                                    format: .dateTime.year().month().day())
                            } else {
                                Text("")
                            }
                            Text(
                                rtran.amount,
                                format: .currency(
                                    code: Locale.current.currency?.identifier ?? "USD"))
                        }
                        .onTapGesture { action in
                            handler(PathStore.Route.recurringTransaction_Details(recTrans: rtran))
                        }

                    }
                }
            }

            Section(header: Text("Transactions"), footer: Text("End of list")) {
                Grid() {
                    GridRow {
                        Text("Name")
                        Text("Account")
                        Text("Created On")
                        Text("Amount")
                    }
                    .font(.headline)
                    ForEach(self.viewModel.transactions, id: \.id) { tran in
                        GridRow {
                            Text("\(tran.name)")
                            Text("\(tran.account.name)")
                            HStack {
                                Text(tran.createdOnUTC,
                                     format: .dateTime.year().month().day())
                            }
                            Text(tran.amount,
                                format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                        .onTapGesture { t in
                            handler(PathStore.Route.transaction_Detail(transaction: tran))
                        }
                    }
                }
            }
        }
        .frame(width: 450)
    }


}

#Preview {
    TagDetailView(tag: MoneyDataSource.shared.previewer.billsTag, { a in debugPrint(a) })
}
