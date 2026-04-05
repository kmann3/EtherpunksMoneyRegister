//
//  GroupItem.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 4/4/26.
//

import Foundation
import SwiftUI

struct RecurringGroupItem: View {
    var item: RecurringGroup

    var body: some View {
        VStack {
            Text(item.name)
                .font(.headline)
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
            HStack {
                Spacer()
                VStack {
                    if(item.recurringTransactions == nil) {
                            Text("No items")
                    } else {
                        ForEach(item.recurringTransactions!.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }) { rt in
                            Text(rt.name)
                        }
                    }
                }
                .padding(10)
                .cornerRadius(10)
                 .overlay(
                     RoundedRectangle(cornerRadius: 10)
                         .stroke(
                             Color(
                                 .sRGB, red: 125 / 255, green: 125 / 255,
                                 blue: 125 / 255, opacity: 0.5
                             ))
                 )
                 .contentShape(Rectangle())
            }
        }
        //         Text(acctData.name)
        //             .frame(maxWidth: .infinity, alignment: .center)
        //             .font(.title2)
        //             .foregroundStyle(.blue)
        //             .padding(
        //                 EdgeInsets(
        //                     .init(top: 2, leading: 0, bottom: 5, trailing: 0)
        //                 )
        //             )
        //         Spacer()
        //     }

        //     Divider()

        //     HStack {
        //         Text("Available")
        //             .font(.headline)
        //             .foregroundStyle(.secondary)
        //             .padding(.horizontal, 15)

        //         Spacer()

        //         Text(
        //             acctData.currentBalance.toDisplayString()
        //         )
        //         .font(.headline)
        //         .foregroundStyle(.secondary)
        //         .padding(.horizontal, 15)
        //     }

        //     HStack {
        //         Text("Exected Balance")
        //             .font(.headline)
        //             .foregroundStyle(.secondary)
        //             .padding(.horizontal, 15)

        //         Spacer()

        //         Text(
        //             (acctData.currentBalance - acctData.outstandingBalance).toDisplayString()
        //         )
        //         .font(.headline)
        //         .foregroundStyle(.secondary)
        //         .padding(.horizontal, 15)
        //     }

        //     Rectangle()
        //         .fill(Color.gray)
        //         .frame(maxWidth: 750, maxHeight: 1, alignment: .center)
        //         .padding(.horizontal, 25)

        //     HStack {
        //         Text("Last Balanced:")
        //             .font(.headline)
        //             .foregroundStyle(.secondary)
        //             .padding(.horizontal, 15)

        //         Spacer()

        //         Text(
        //             acctData.lastBalancedUTC?.toSummaryDateMMMDY() ?? "never"
        //         )
        //         .font(.headline)
        //         .foregroundStyle(.secondary)
        //         .padding(.horizontal, 15)
        //     }
        // }

#if os(macOS)
            .padding(.all, 5)
#endif
    }
}

#Preview {
    RecurringGroupItem(item: MoneyDataSource.shared.previewer.billGroup)
}
