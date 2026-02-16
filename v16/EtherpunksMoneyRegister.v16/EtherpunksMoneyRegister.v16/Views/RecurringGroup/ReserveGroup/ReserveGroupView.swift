//
//  ReserveGroupView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import SwiftUI

struct ReserveGroupView: View {
    var viewModel: ViewModel
    var handler: ([AccountTransactionQueueItem])-> Void

    init(_ group: RecurringGroup, _ handler: @escaping ([AccountTransactionQueueItem]) -> Void) {
        self.viewModel = ViewModel(reserveGroup: group)
        self.handler = handler
    }

    var body: some View {
        VStack {
            HStack {
                Text("Reserve Transactions: \(self.viewModel.reserveGroup.name)")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundStyle(.blue)
                    .padding(
                        EdgeInsets(
                            .init(top: 2, leading: 0, bottom: 5, trailing: 0)
                        )
                    )
                Spacer()
            }

            Divider()

            Grid {
                GridRow {
                    Text("Account").bold()
                    Text("Name").bold()
                    Text("Due Date").bold()
                    Text("Amount").bold()
                    Text("Action").bold()
                }

                ForEach(self.viewModel.transactionQueue) { rt in
                    GridRow {
                        Picker("", selection: Binding(
                            get: { rt.accountTransaction.account },
                            set: { rt.accountTransaction.account = $0 }
                        )) {
                            ForEach(self.viewModel.accounts) { acc in
                                Text(acc.name).tag(acc)
                            }
                        }
                        .pickerStyle(.menu)

                        Text(rt.accountTransaction.name)

                        if rt.accountTransaction.dueDate == nil {
                            Text("n/a")
                        } else {
                            Text(rt.accountTransaction.dueDate!,
                                 format: .dateTime.month().day())
                        }

                        Text(rt.accountTransaction.amount.toDisplayString())
                            .frame(maxWidth: .infinity, alignment: .center)



                        Picker("", selection: Binding(
                              get: { rt.action },
                              set: { rt.action = $0 }
                          )) {
                              Text("Reserve").tag(ReserveGroupView.Action.enable)
                              Text("Skip").tag(ReserveGroupView.Action.skip)
                              Text("Ignore").tag(ReserveGroupView.Action.ignore)
                          }

                    }
                }
            }

            Divider()

            HStack {
                Button("Cancel") {}
                    .frame(minWidth: 100, alignment: .center)
                    .padding(.bottom, 5)

                Spacer()

                Button("Reserve") {
                    self.viewModel.saveTransactions()
                    handler(self.viewModel.transactionQueue)
                }
                .frame(minWidth: 100, alignment: .center)
                .padding(.bottom, 5)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title2)
            .foregroundStyle(.blue)
            .padding(
                EdgeInsets(
                    .init(top: 2, leading: 0, bottom: 5, trailing: 0)
                )
            )
            Divider()
            HStack {
                Text("Note on action:")
                Spacer()
            }
            HStack {
                Text("Skip = Bump the due date but don't create the transaction")
                Spacer()
            }
            HStack {
                Text("Ignore = Don't bump the due date, don't create the transaction;")
                Spacer()
            }
            HStack {
                Text("\t as in you will handle this at a later date")
                Spacer()
            }
        }
        .frame(minWidth: 450)
    }
}

#Preview {
    ReserveGroupView(MoneyDataSource.shared.previewer.billGroup) { action in print(action) }
}
