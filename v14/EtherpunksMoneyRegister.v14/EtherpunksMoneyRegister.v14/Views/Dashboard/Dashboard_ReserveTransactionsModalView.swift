//
//  Dashboard_ReserveTransactionsModalView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/7/25.
//

import SwiftUI
import SwiftData

struct Dashboard_ReserveTransactionsModalView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Query(sort: [SortDescriptor(\Account.name, comparator: .localizedStandard)]) var accountList: [Account]

    let reserveList: [RecurringTransaction]

    @Binding var selectedAccount: Account?
    @Binding var didCancel: Bool

    init(reserveList: [RecurringTransaction], selectedAccount: Binding<Account?>, didCancel: Binding<Bool>) {
        self.reserveList = reserveList.sorted(by: {$0.name < $1.name })
        _selectedAccount = selectedAccount
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
                        .padding(.bottom, 10)

                    VStack {
                        ForEach(self.reserveList) { transaction in
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
                        ForEach(self.accountList) { account in
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
                    //self.reserveList(list: reserveList, account: selectedAccount!)
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
    Dashboard_ReserveTransactionsModalView(
        reserveList: [p.discordRecurringTransaction, p.verizonRecurringTransaction],
        selectedAccount: .constant(p.bankAccount),
        didCancel: .constant(false)
    )
    .modelContainer(p.container)
}
