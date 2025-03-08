//
//  Dashboard_AccountViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/6/25.
//

import SwiftUI

struct Dashboard_AccountItemView: View {
    var acctData: Account

    var body: some View {
        VStack {
            HStack {
                Text(acctData.name)
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
                Text("Available")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 15)

                Spacer()

                Text(
                    acctData.currentBalance,
                    format: .currency(
                        code: Locale.current.currency?.identifier ?? "USD")
                )
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 15)
            }

            HStack {
                Text("Exected Balance")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 15)

                Spacer()

                Text(
                    acctData.currentBalance - acctData.outstandingBalance,
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

            HStack {
                Text("Last Balanced:")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 15)

                Spacer()

                Text(
                    acctData.lastBalancedUTC?.toSummaryDateMMMDY() ?? "never"
                )
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 15)
            }
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    Color(
                        .sRGB, red: 125 / 255, green: 125 / 255,
                        blue: 125 / 255, opacity: 0.5))
        )
        .contentShape(Rectangle())
#if os(macOS)
        .padding(.all, 5)
#endif
    }
}

#Preview {
    //let ds = MoneyDataSource()
    Dashboard_AccountItemView(acctData: MoneyDataSource.shared.previewer.bankAccount)
}
