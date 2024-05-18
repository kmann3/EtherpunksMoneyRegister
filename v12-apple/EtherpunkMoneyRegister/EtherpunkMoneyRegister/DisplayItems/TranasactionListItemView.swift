//
//  TranasactionItemListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftUI

struct TranasactionListItemView: View {
    
    let item: TransactionListItem
    
    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                Text(item.amount.formatted())
                if let pendingText: Date = self.item.pending?.advanced(by: 0) {
                    Text(pendingText, format: .dateTime.month().day())
                } else {
                    Text("Pending")
                }
                if let clearedText: Date = self.item.cleared?.advanced(by: 0) {
                    Text(clearedText, format: .dateTime.month().day())
                } else {
                    Text("Cleared")
                }
            }
        }
        .padding()
        .background(item.backgroundColor)
    }
}

#Preview("Reserved Transaction", traits: .defaultLayout) {
    let previewItem: TransactionListItem = TransactionListItem(name: "Burger King", amount: 13.73, pending: nil, cleared: nil)
    return TranasactionListItemView(item: previewItem)
}

#Preview("Pending Transaction", traits: .defaultLayout) {
    let previewItem: TransactionListItem = TransactionListItem(name: "Burger King", amount: 13.73, pending: Date(), cleared: nil)
    return TranasactionListItemView(item: previewItem)
}

#Preview("Regular TransactionData", traits: .defaultLayout) {
    let previewItem: TransactionListItem = TransactionListItem(name: "Burger King", amount: 13.73, pending: nil, cleared: Date())
    return TranasactionListItemView(item: previewItem)
}
