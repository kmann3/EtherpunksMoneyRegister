//
//  TransactionItemListView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/20/24.
//

import SwiftUI

struct TransactionListItemView: View {
    let transaction: AccountTransaction
    let showBalance: Bool
    let renderBackgroundColor: Bool
    @State private var opacity = 1.0
    @State private var isFadingOut: Bool = true

    init(transaction: AccountTransaction, showBalance: Bool = true, renderBackgroundColor: Bool = true) {
        self.transaction = transaction
        self.showBalance = showBalance
        self.renderBackgroundColor = renderBackgroundColor

        withAnimation(.linear(duration: 3)) {
            if isFadingOut {
                opacity -= 0.2
            } else {
                opacity += 0.2
            }

            if opacity == 0.0 {
                isFadingOut = false
            } else if opacity == 1.0 {
                isFadingOut = true
            }
        }
    }
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
                    Text(
                        transaction.amount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD")
                    )
                    .foregroundStyle(.green)
                } else {
                    Text(
                        transaction.amount,
                        format: .currency(
                            code: Locale.current.currency?.identifier ?? "USD"))
                }
            }

            HStack(spacing: 0) {
                if transaction.pendingOnUTC == nil
                    && transaction.clearedOnUTC == nil
                {
                    Text("Reserved")
                } else if transaction.pendingOnUTC != nil
                    && transaction.clearedOnUTC == nil
                {
                    Text("Pending")
                } else {
                    if let clearedText: Date = self.transaction.clearedOnUTC?
                        .advanced(
                            by: 0
                        )
                    {
                        Text(clearedText, format: .dateTime.month().day())
                    }
                }

                Spacer()

                if showBalance {
                    HStack {
                        Text("Bal:")
                        Text(
                            transaction.balance ?? 0,
                            format:
                                    .currency(
                                        code: Locale.current.currency?.identifier
                                        ?? "USD"
                                    )
                        )
                        .font(.caption)
                    }
                }
            }

            HStack(spacing: 0) {
                if transaction.transactionTags != nil {
                    ForEach(transaction.transactionTags!) { tag in
                        Text("\(tag.name) ")
                            .font(.callout)
                    }

                    Spacer()

                    if transaction.fileCount > 0 {
                        HStack {
                            Text(Image(systemName: "paperclip"))
                                .font(.caption2)
                            Text("x \(transaction.fileCount)")
                        }
                    }
                }
            }
        }
        .opacity(opacity)
        .background(renderBackgroundColor ? transaction.backgroundColor : Color.clear)
        .contentShape(Rectangle())
    }
}

#Preview {
    let previewer = Previewer()

    TransactionListItemView(transaction: previewer.cvsTransaction)
        .modelContainer(previewer.container)
}
