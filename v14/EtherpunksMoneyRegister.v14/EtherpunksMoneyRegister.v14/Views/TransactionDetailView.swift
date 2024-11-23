//
//  TransactionDetailView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/23/24.
//

import SwiftUI

struct TransactionDetailView: View {
    var transactionItem: AccountTransaction

    init(transactionItem: AccountTransaction) {
        self.transactionItem = transactionItem
    }

    var body: some View {
        Text("Transaction Details")
    }
}

#Preview {
    let p = Previewer()
    TransactionDetailView(transactionItem: p.cvsTransaction)
}
