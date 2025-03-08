//
//  Dashboard_ReserveTransactionsDepositCreditDialogView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import SwiftUI
import Combine

struct Dashboard_ReserveTransactionsDepositCreditDialogView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.locale) private var locale

    @StateObject var viewModel: ViewModel
    @Binding var didCancel: Bool
    @Binding var returnTransaction: AccountTransaction

    @State var isCleared: Bool = false

    init(reserveTransaction: RecurringTransaction,
         returnTransaction: Binding<AccountTransaction>,
         didCancel: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: ViewModel(transactionToReserve: reserveTransaction))
        _didCancel = didCancel
        _returnTransaction = returnTransaction
    }

    var body: some View {
        VStack {
            HStack {
                Text("Deposit Credit")
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
                    Text("Transaction")
                        .padding(.trailing, 25)
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Divider()

                    Text(viewModel.reserveTransaction.name)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color(
                                    .sRGB, red: 125 / 255, green: 125 / 255,
                                    blue: 125 / 255, opacity: 0.5))
                    )
                    .frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 30)
                }

                VStack {
                    Text("Details")
                        .padding(.trailing, 25)
                        .padding(.bottom, 25)
                        .frame(maxWidth: .infinity, alignment: .center)

                    VStack {
                        Picker("Account", selection: $returnTransaction.account) {
                            ForEach(viewModel.accounts) { account in
                                Text(account.name)
                                    .tag(account)
                            }
                        }

                        HStack {
                            Text("Amount")
                            TextField("Amount", value: $returnTransaction.amount, format: .currency(code: locale.currency?.identifier ?? "USD"))
                        }

                        HStack {
                            NullableDatePicker(name: "Date", selectedDate: $returnTransaction.pendingOnUTC)
                            Spacer()
                        }

                        HStack {
                            Toggle("Is Cleared?", isOn: $isCleared)
                            #if os(macOS)
                                .toggleStyle(.checkbox)
                            #endif
                                .onChange(of: isCleared) {
                                    if isCleared == true {
                                        returnTransaction.clearedOnUTC = Date()
                                    } else {
                                        returnTransaction.clearedOnUTC = nil
                                    }
                                }
                            Spacer()
                        }

                        HStack {
                            Text("Notes")
                            TextField("Notes", text: $returnTransaction.notes, axis: .vertical)
                                .lineLimit(3...10)

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
    }
}

#Preview {
    @Previewable @State var amount: Decimal = 43.54
    @Previewable @State var depositeDate: Date? = nil
    let p = MoneyDataSource.shared.previewer
    Dashboard_ReserveTransactionsDepositCreditDialogView(
        reserveTransaction: p.discordRecurringTransaction,
        returnTransaction: .constant(p.cvsTransaction),
        didCancel: .constant(false)
    )
}
