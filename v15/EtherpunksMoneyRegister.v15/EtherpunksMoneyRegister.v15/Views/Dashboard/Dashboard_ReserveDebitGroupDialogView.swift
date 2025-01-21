//
//  Dashboard_ReserveTransactionsDialogView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import SwiftUI

struct Dashboard_ReserveDebitGroupDialogView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ViewModel
    @Binding var didCancel: Bool
    @Binding var returnTransactions: [AccountTransaction]

    init(reserveGroup: RecurringGroup, returnTransactions: Binding<[AccountTransaction]>, didCancel: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(groupToReserve: reserveGroup))
        _returnTransactions = returnTransactions
        _didCancel = didCancel
    }

    var body: some View {
        VStack {
            HStack {
                Text("Reserve Transactions")
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

            HStack {
                VStack {
                    Text("Transactions")
                        .padding(.trailing, 25)
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack {
                        ForEach(viewModel.reserveGroup.recurringTransactions!.sorted(by: {$0.name < $1.name})) { t in
                            Text(t.name)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color(
                                    .sRGB, red: 125 / 255, green: 125 / 255,
                                    blue: 125 / 255, opacity: 0.5))
                    )
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                VStack {
                    Text("Accounts")
                        .padding(.trailing, 25)
                        .padding(.bottom, 25)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Picker("Account", selection: $viewModel.selectedAccount) {
                        ForEach(viewModel.accounts.sorted(by: {$0.name < $1.name})) { account in
                            Text(account.name)
                                .tag(account)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color(
                                    .sRGB, red: 125 / 255, green: 125 / 255,
                                    blue: 125 / 255, opacity: 0.5))
                    )
                    .frame(minWidth: 300, maxWidth: .infinity, alignment: .center)

                }
            }

            Divider()

            HStack {
                Button {
                    didCancel = true
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .frame(minWidth: 100, alignment: .center)
                .padding(.bottom, 5)

                Spacer()

                Button {
                    returnTransactions.forEach { t in
                        t.account = viewModel.selectedAccount
                    }
                    didCancel = false
                    dismiss()
                } label: {
                    Text("Save")
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
    let p = Previewer()
    Dashboard_ReserveDebitGroupDialogView(reserveGroup: p.billGroup, returnTransactions: .constant([p.discordTransaction]), didCancel: .constant(false)
    )
}
