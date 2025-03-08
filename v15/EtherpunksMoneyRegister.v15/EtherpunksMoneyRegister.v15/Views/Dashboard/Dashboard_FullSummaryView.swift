//
//  Dashboard_AccountViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/6/25.
//

import SwiftUI

struct Dashboard_FullSummaryView: View {
    var accounts: [Account]

    init(accounts: [Account]) {
        self.accounts = accounts
    }

    var body: some View {
        VStack {
            HStack {
                Text("Full Summary")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .foregroundStyle(.yellow)
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
                    .padding(.horizontal, 15)

                Spacer()

                Text(
                    accounts.reduce((Decimal(0))) {$0 + $1.currentBalance},
                    format: .currency(
                        code: Locale.current.currency?.identifier ?? "USD")
                )
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 15)
            }

            Rectangle()
                .fill(Color.gray)
                .frame(maxWidth: 750, maxHeight: 1, alignment: .center)
                .padding(.horizontal, 25)

            Text("Outstanding")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            HStack {
                Text("Items:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 15)

                Spacer()

                Text(accounts.reduce(0) {$0 + $1.outstandingItemCount}.description)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 15)
            }

            HStack {
                Text("Amount:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 15)

                Spacer()

                Text(
                    accounts.reduce(Decimal(0)) {$0 + $1.outstandingBalance},
                    format: .currency(
                        code: Locale.current.currency?.identifier ?? "USD")
                )
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 15)
            }
        }
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color(
                        .sRGB, red: 200 / 255, green: 200 / 255,
                        blue: 200 / 255, opacity: 0.9))
        )
        .contentShape(Rectangle())
#if os(macOS)
        .padding(.all, 10)
#endif
    }
}

#Preview {
    let p = MoneyDataSource.shared.previewer
    Dashboard_FullSummaryView(accounts: [p.bankAccount])
}
