//
//  TranasactionItemListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftUI

struct TransactionListItemView: View {
    
    let item: TransactionListItem
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text(item.transaction.name)
                Spacer()
                if(item.transaction.amount > 0) {
                    Text(item.transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .foregroundStyle(.green)
                } else {
                    Text(item.transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            
            HStack(spacing: 0) {
                if(item.transaction.pending == nil && item.transaction.cleared == nil) {
                    Text("Reserved")
                } else if (item.transaction.pending != nil && item.transaction.cleared == nil) {
                    Text("Pending")
                } else {
                    if let clearedText: Date = self.item.transaction.cleared?.advanced(by: 0) {
                        Text(clearedText, format: .dateTime.month().day())
                    }
                }
                
                Spacer()
                
                Text(item.transaction.balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .font(.caption)
            }
            
            HStack(spacing: 0) {
                if(item.transaction.tags != nil) {
                    ForEach(item.transaction.tags ?? [Tag(name: "EMPTY")]){ tag in
                        Text(tag.name)
                            .font(.callout)
                    }
                    Spacer()
                    if(item.transaction.fileCount > 0) {
                        Text(Image(systemName: "paperclip"))
                            .font(.caption2)
                    }
                    
                }
            }
            
        }
        .background(item.backgroundColor)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionListItemView(item: TransactionListItem(transaction: previewer.burgerKingTransaction))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
