//
//  ReserveGroupViewView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/25/25.
//

import SwiftUI

struct ReserveGroupViewView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(group: RecurringGroup, _ handler: @escaping (PathStore.Route) -> Void) {
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

            Grid() {
                GridRow {
                    Text("Name")
                    Text("Due Date")
                    Text("Amount")
                    Text("Account")
                }

                ForEach(self.viewModel.transactionQueue, id: \.accountTransaction.id) { rt in
                    GridRow {
                        Text(rt.accountTransaction.name)

                        if rt.accountTransaction.dueDate == nil {
                            Text("n/a")
                        } else {
                            Text(rt.accountTransaction.dueDate!,
                                 format: .dateTime.month().day())
                        }

                        Text(rt.accountTransaction.amount,
                             format: .currency(code: Locale.current.currency?.identifier ?? "USD"))

                            Text("acc")
//                            Picker("Account", selection: $viewModel.selectedAccount) {
//                                ForEach(viewModel.accounts.sorted(by: {$0.name < $1.name})) { account in
//                                    Text(account.name)
//                                        .tag(account)
//                                }
//                            }
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 25)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(
//                                        Color(
//                                            .sRGB, red: 125 / 255, green: 125 / 255,
//                                            blue: 125 / 255, opacity: 0.5))
//                            )
//                            .frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
                    }
                }

            }

//            HStack {
//                VStack {
//                    Text("Transactions")
//                        .padding(.trailing, 25)
//                        .padding(.bottom, 5)
//                        .frame(maxWidth: .infinity, alignment: .center)
//
//                     VStack {
//                         ForEach(viewModel.reserveGroup.recurringTransactions!.sorted(by: {$0.name < $1.name})) { t in
//                             Text(t.name)
//                         }
//                     }
//                     .padding(.vertical, 10)
//                     .padding(.horizontal, 25)
//                     .overlay(
//                         RoundedRectangle(cornerRadius: 10)
//                             .stroke(
//                                 Color(
//                                     .sRGB, red: 125 / 255, green: 125 / 255,
//                                     blue: 125 / 255, opacity: 0.5))
//                     )
//                     .frame(maxWidth: .infinity, alignment: .center)
//                }
//
//                VStack {
//                    Text("Acc")
//                     Text("Use Default Account")
//
//                     Text("If no default account use: ")
//                         .padding(.trailing, 25)
//                         .padding(.bottom, 25)
//                         .frame(maxWidth: .infinity, alignment: .center)
//
//                     Picker("Account", selection: $viewModel.selectedAccount) {
//                         ForEach(viewModel.accounts.sorted(by: {$0.name < $1.name})) { account in
//                             Text(account.name)
//                                 .tag(account)
//                         }
//                     }
//                     .padding(.vertical, 10)
//                     .padding(.horizontal, 25)
//                     .overlay(
//                         RoundedRectangle(cornerRadius: 10)
//                             .stroke(
//                                 Color(
//                                     .sRGB, red: 125 / 255, green: 125 / 255,
//                                     blue: 125 / 255, opacity: 0.5))
//                     )
//                     .frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
//
//                }
//            }

            Divider()

            HStack {
                Button {
                } label: {
                    Text("Cancel")
                }
                .frame(minWidth: 100, alignment: .center)
                .padding(.bottom, 5)

                Spacer()

                Button {
                } label: {
                    Text("Reserve")
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
        }
    }
}

#Preview {
    let p = MoneyDataSource.shared.previewer
    ReserveGroupViewView(group: p.billGroup) { action in debugPrint(action) }
}
