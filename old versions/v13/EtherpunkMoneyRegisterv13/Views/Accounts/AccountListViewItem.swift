//
//  AccountListViewItem.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/18/24.
//
// TODO: I don't exactly like how this appears. It's too many items and having lines between it all looks goofy.

import SwiftUI

struct AccountListItemView: View {
    var acctData: AccountListViewItemData

    var body: some View {
        VStack {
            HStack {
                Text(acctData.account.name)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundStyle(.secondary)
                    .padding(
                        EdgeInsets(
                            .init(top: 2, leading: 0, bottom: 5, trailing: 0)
                        )
                    )
                Spacer()
            }

            Divider()

            HStack {
                Text("Available")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)

                Spacer()

                Text(acctData.account.currentBalance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }

            HStack {
                Text("Exected Balance")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)

                Spacer()

                Text(acctData.account.currentBalance - acctData.account.outstandingBalance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }

            Rectangle().fill(Color.gray).frame(width: .infinity, height: 1, alignment: .center).padding(.horizontal, 25)

            HStack {
                Text("Oustanding")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)

                Spacer()

                Text(acctData.account.outstandingBalance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }

            HStack {
                Spacer()

                Text("\(acctData.account.outstandingItemCount) Items")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }

            HStack {
                Text("Last Balanced:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)

                Spacer()

                Text(acctData.account.lastBalancedLocal, format: .dateTime.month().day().year())
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
            }

            HStack {
                Text("Transaction Count:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)

                Spacer()

                Text("\(acctData.transactionCount) Items")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 5)
                    .padding(.bottom, 5)
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 125/255, green: 125/255, blue: 125/255, opacity: 0.5))
        )
        #if os(macOS)
        .padding(.all, 5)
        #endif
    }
}

#Preview {
    let account = Previewer.bankAccount
    let acctData = AccountListViewItemData(account: account, transactionCount: 2347913)
    return AccountListItemView(acctData: acctData)
}
