//
//  TransactionListItemView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/14/26.
//

import SwiftUI

struct TransactionListItemView: View {
    let transaction: AccountTransaction

    var body: some View {
        VStack {
            HStack(spacing: 0) {
                if transaction.balancedOnUTC != nil {
                    Text(Image(systemName: "checkmark.seal"))
                        .font(.caption2)
                        .foregroundStyle(.cyan)
                }
                Text(transaction.name)
                Spacer()
                if transaction.amount > 0 {
                    Text(transaction.amount.toDisplayString())
                        .foregroundStyle(.green)
                } else {
                    Text(transaction.amount.toDisplayString())
                }
            }

            HStack(spacing: 0) {
                if transaction.pendingOnUTC == nil && transaction.clearedOnUTC == nil {
                    Text("Reserved")
                } else if transaction.pendingOnUTC != nil && transaction.clearedOnUTC == nil {
                    Text("Pending")
                } else {
                    if let clearedText: Date = self.transaction.clearedOnUTC?.advanced(by: 0) {
                        Text(clearedText, format: .dateTime.month().day())
                    }
                }

                Spacer()

                Text(transaction.balance?.toDisplayString() ?? "")
                    .font(.caption)
            }

            HStack(spacing: 0) {
                if transaction.transactionTags.count > 0 {
                    ForEach(transaction.transactionTags) { tag in
                        Text("\(tag.name) ")
                            .font(.callout)
                    }
                    Spacer()
                    if transaction.fileCount > 0 {
                        Text(Image(systemName: "paperclip"))
                            .font(.caption2)
                        Text("x\(transaction.fileCount)")
                    }
                }
            }
        }
        .background(transaction.backgroundColor)
    }
}

#Preview {
    TransactionListItemView(transaction: MoneyDataSource.shared.previewer.cvsTransaction)
}
