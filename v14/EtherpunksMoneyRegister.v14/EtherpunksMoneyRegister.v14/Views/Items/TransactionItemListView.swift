//
//  TransactionItemListView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/20/24.
//

import SwiftUI

struct TransactionListItemView: View {
    let transaction: AccountTransaction

    var body: some View {
        VStack {
            HStack(spacing: 0) {
//                if transaction.balancedOn != nil {
//                    Text(Image(systemName: "checkmark.seal"))
//                        .font(.caption2)
//                        .foregroundStyle(.cyan)
//                }
                Text(transaction.name)
                Spacer()
                if transaction.amount > 0 {
                    Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(.green)
                } else {
                    Text(transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }

            HStack(spacing: 0) {
                if transaction.pendingOnUTC == nil && transaction.clearedOnUTC == nil {
                    Text("Reserved")
                } else if transaction.pendingOnUTC != nil && transaction.clearedOnUTC == nil {
                    Text("Pending")
                } else {
                    if let clearedText: Date = self.transaction.clearedOnUTC?.advanced(
                        by: 0
                    ) {
                        Text(clearedText, format: .dateTime.month().day())
                    }
                }

                Spacer()

                HStack {
                    Text("Bal:")
                    Text(
                        transaction.balance ?? 0,
                        format:
                                .currency(
                                    code: Locale.current.currency?.identifier ?? "USD"
                                )
                    )
                    .font(.caption)
                }
            }

            HStack(spacing: 0) {
                if transaction.transactionTags != nil {
                    ForEach(transaction.transactionTags!) { tag in
                        Text("\(tag.name) ")
                            .font(.callout)
                    }
                    Spacer()
//                    if transaction.fileCount > 0 {
//                        Text(Image(systemName: "paperclip"))
//                            .font(.caption2)
//                    }
                }
            }
        }
        .background(transaction.backgroundColor)
    }
}

#Preview {
        let previewer = Previewer()

        TransactionListItemView(transaction: previewer.cvsTransaction)
            .modelContainer(previewer.container)
}
