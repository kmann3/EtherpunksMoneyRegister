//
//  Dashboard_ReserveTransactionsModalView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/7/25.
//

import SwiftUI

struct Dashboard_ReserveTransactionsModalView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    var reserveList: [RecurringTransaction]
    var accountList: [Account]

    @State var selectedAccount: Account

    init(reserveList: [RecurringTransaction], accountList: [Account]) {
        self.reserveList = reserveList.sorted(by: {$0.name < $1.name })
        self.accountList = accountList.sorted(by: {$0.name < $1.name })
        selectedAccount = accountList.first!
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    ForEach(self.reserveList) { transaction in
                        Text(transaction.name)
                    }
                    .frame(minWidth: 100, maxWidth: 300, alignment: .center)

                    HStack {

                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        .frame(minWidth: 100, alignment: .center)
                        .padding(.top, 15)
                        Spacer()
                            .frame(width: 50)
                    }
                }

                Text("-->")

                VStack {
                    Picker("Account", selection: $selectedAccount) {
                        ForEach(self.accountList) { account in
                            Text(account.name)
                                .tag(account)
                        }
                    }
                    .frame(minWidth: 200, maxWidth: 300)

                    HStack {
                        Spacer()
                        .frame(width: 150)
                        Button {
                            // Save and then dismiss
                            dismiss()
                        } label: {
                            Text("Save")
                        }
                        .frame(width: 150, alignment: .center)
                        .padding(.top, 15)
                    }
                }
            }

            HStack {

            }
        }
    }
}

#Preview {
    let p = Previewer()
    Dashboard_ReserveTransactionsModalView(reserveList: [p.discordRecurringTransaction, p.verizonRecurringTransaction], accountList: [p.bankAccount])
        .modelContainer(p.container)
}
