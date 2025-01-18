//
//  Dashboard_ReserveTransactionsDialogView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import SwiftUI
import Combine

struct Dashboard_ReserveTransactionsCreditDepositDialogView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) private var locale

    @StateObject var viewModel: ViewModel
    @Binding var didCancel: Bool
    @Binding var selectedAccount: Account?
    @Binding var amount: Decimal?
    @Binding var depositeDate: Date?

    init(reserveTransaction: RecurringTransaction,
         selectedAccount: Binding<Account?>,
         amount: Binding<Decimal?>,
         depositeDate: Binding<Date?>,
         didCancel: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(transactionToReserve: reserveTransaction))
        _didCancel = didCancel
        _selectedAccount = selectedAccount
        _depositeDate = depositeDate
        _amount = amount
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

                    Text(viewModel.reserveTransaction.name)
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
                    Text("Details")
                        .padding(.trailing, 25)
                        .padding(.bottom, 25)
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack {
                        Picker("Account", selection: $selectedAccount) {
                            ForEach(viewModel.accounts) { account in
                                Text(account.name)
                                    .tag(account)
                            }
                        }

                        HStack {
                            Text("Amount")
                            TextField("Amount", value: $amount, format: .currency(code: locale.currency?.identifier ?? "USD"))
                        }

                        HStack {
                            NullableDatePicker(name: "Date", selectedDate: $depositeDate)
                            Spacer()
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
                    .frame(minWidth: 400, maxWidth: .infinity, alignment: .center)

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
    @Previewable @State var amount: Decimal? = 43.55
    @Previewable @State var depositeDate: Date? = nil
    let p = Previewer()
    Dashboard_ReserveTransactionsCreditDepositDialogView(
        reserveTransaction: p.discordRecurringTransaction,
        selectedAccount: .constant(p.bankAccount),
        amount: $amount,
        depositeDate: $depositeDate,
        didCancel: .constant(false)
    )
}
