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
        HStack(spacing: 0) {
            Text(item.transaction.name).padding().border(Color.gray, width: 1)
            Text(item.transaction.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD")).padding().border(Color.gray, width: 1)
            if let pendingText: Date = self.item.transaction.pending?.advanced(by: 0) {
                Text(pendingText, format: .dateTime.month().day()).padding().border(Color.gray, width: 1)
            } else {
                Text("Pending").padding().border(Color.gray, width: 1)
            }
            if let cleagrayText: Date = self.item.transaction.cleared?.advanced(by: 0) {
                Text(cleagrayText, format: .dateTime.month().day()).padding().border(Color.gray, width: 1)
            } else {
                Text("Cleared").padding().border(Color.gray, width: 1)
            }
            Text(item.transaction.balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD")).padding().border(Color.gray, width: 1)

        }
        }
        .background(item.backgroundColor)
    }
}
