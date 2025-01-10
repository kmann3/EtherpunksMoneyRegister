//
//  Dashboard_ReserveTransactionsDialogView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import SwiftUI

struct Dashboard_ReserveTransactionsDialogView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel: ViewModel
    @Binding var didCancel: Bool
    @Binding var selectedAccount: Account?

    init(reserveList: [RecurringTransaction], selectedAccount: Binding<Account?>, didCancel: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(listToReserve: reserveList))
        _didCancel = didCancel
        _selectedAccount = selectedAccount
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
                        .padding(.bottom, 10)

                    VStack {
                        ForEach(viewModel.reserveList) { transaction in
                            Text(transaction.name)
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

                    Picker("Account", selection: $selectedAccount) {
                        ForEach(viewModel.accounts) { account in
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
                    .frame(maxWidth: .infinity, alignment: .center)

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
        .onAppear {
            selectedAccount = viewModel.accounts.first!
        }
    }
}

#Preview {
    let p = Previewer()
    Dashboard_ReserveTransactionsDialogView(
        reserveList: [p.discordRecurringTransaction, p.verizonRecurringTransaction],
        selectedAccount: .constant(p.bankAccount),
        didCancel: .constant(false)
    )
}
