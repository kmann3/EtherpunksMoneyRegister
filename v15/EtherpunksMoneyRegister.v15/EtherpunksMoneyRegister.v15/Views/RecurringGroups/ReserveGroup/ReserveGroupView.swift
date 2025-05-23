//
//  ReserveGroupViewView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/25/25.
//

import SwiftUI

struct ReserveGroupView: View {
    @StateObject var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(_ group: RecurringGroup, _ handler: @escaping (PathStore.Route) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(reserveGroup: group))
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
                    Text("Action").bold()
                    Text("Name").bold()
                    Text("Due Date").bold()
                    Text("Amount").bold()
                    Text("Account").bold()
                }

                ForEach($viewModel.transactionQueue) { $rt in
                    GridRow {
                        Picker("", selection: $rt.action) {
                            Text("Reserve").tag(Action.enable)
                            Text("Skip").tag(Action.skip)
                            Text("Ignore").tag(Action.ignore)
                        }
                        Text(rt.accountTransaction.name)

                        if rt.accountTransaction.dueDate == nil {
                            Text("n/a")
                        } else {
                            Text(rt.accountTransaction.dueDate!,
                                 format: .dateTime.month().day())
                        }

                        Text(rt.accountTransaction.amount.toDisplayString())
                            .frame(maxWidth: .infinity, alignment: .center)

                        Picker("", selection: $rt.accountTransaction.account) {
                            ForEach($viewModel.accounts) { $acc in
                                Text(acc.name).tag(acc)
                            }
                        }
                        .pickerStyle(.menu)
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
                    handler(PathStore.Route.dashboard)
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
    }
}

#Preview {
    ReserveGroupView(MoneyDataSource.shared.previewer.billGroup) { action in print(action) }
}
