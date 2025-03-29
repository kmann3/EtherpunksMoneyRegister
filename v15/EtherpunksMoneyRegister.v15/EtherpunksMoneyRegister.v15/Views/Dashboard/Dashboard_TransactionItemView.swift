//
//  Dashboard_TransactionItemView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/9/25.
//

import SwiftUI

struct Dashboard_TransactionItemView: View {
    let transaction: AccountTransaction

    init(transaction: AccountTransaction) {
        self.transaction = transaction
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
                        transaction.amount.toDisplayString()
                    )
                    .foregroundStyle(.green)
                } else {
                    Text(
                        transaction.amount.toDisplayString())
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
        .background(transaction.backgroundColor)
        .contentShape(Rectangle())
    }
}
#Preview("Reserved") {
    Dashboard_TransactionItemView(
        transaction: AccountTransaction(
            account: Account(name: "Test", startingBalance: 50.00),
            name: "Test Transaction",
            transactionType: .debit,
            amount: 13.73,
            balance: 50.00
        )
    )
}

#Preview("Pending") {
    Dashboard_TransactionItemView(
        transaction: AccountTransaction(
            account: Account(name: "Test", startingBalance: 50.00),
            name: "Test Transaction",
            transactionType: .debit,
            amount: 13.73,
            balance: 50.00,
            pendingOnUTC: Date()
        )
    )
}
#Preview("Cleared") {
    Dashboard_TransactionItemView(
        transaction: AccountTransaction(
            account: Account(name: "Test", startingBalance: 50.00),
            name: "Test Transaction",
            transactionType: .debit,
            amount: 13.73,
            balance: 50.00,
            pendingOnUTC: Date(),
            clearedOnUTC: Date()
        )
    )
}
