//
//  TranasactionItemListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftUI

struct TransactionListItemView: View {
    let transaction: AccountTransaction
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                if transaction.balancedOn != nil {
                    Text(Image(systemName: "checkmark.seal"))
                        .font(.caption2)
                        .foregroundStyle(.cyan)
                }
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
                if transaction.pending == nil && transaction.cleared == nil {
                    Text("Reserved")
                } else if transaction.pending != nil && transaction.cleared == nil {
                    Text("Pending")
                } else {
                    if let clearedText: Date = self.transaction.cleared?.advanced(by: 0) {
                        Text(clearedText, format: .dateTime.month().day())
                    }
                }
                
                Spacer()
                
                Text(transaction.balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.caption)
            }
            
            HStack(spacing: 0) {
                if transaction.tags != nil {
                    ForEach(transaction.tags!) { tag in
                        Text("\(tag.name) ")
                            .font(.callout)
                    }
                    Spacer()
                    if transaction.fileCount > 0 {
                        Text(Image(systemName: "paperclip"))
                            .font(.caption2)
                    }
                }
            }
        }
        .background(transaction.backgroundColor)
    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return TransactionListItemView(transaction: previewer.cvsTransaction)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
