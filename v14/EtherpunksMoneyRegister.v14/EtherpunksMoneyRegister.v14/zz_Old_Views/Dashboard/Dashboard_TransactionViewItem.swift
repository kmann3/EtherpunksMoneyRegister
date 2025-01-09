//
//  Dashboard_TransactionViewItem.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/6/25.
//

import SwiftUI

struct Dashboard_TransactionViewItem: View {
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

#Preview {
    Dashboard_TransactionViewItem(transaction: Previewer().discordTransaction)
        .modelContainer(Previewer().container)
        .environment(PathStore())
}
