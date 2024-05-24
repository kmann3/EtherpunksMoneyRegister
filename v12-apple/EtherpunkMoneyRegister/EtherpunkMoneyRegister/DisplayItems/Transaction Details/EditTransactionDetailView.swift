//
//  EditTransactionDetailView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import SwiftUI

struct EditTransactionDetailView: View {
    var transaction: AccountTransaction
    
    var body: some View {
        Text("Edit Transaction")
        Text("Name: \(transaction.name)")
        Text("Id: \(transaction.id)")

    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return EditTransactionDetailView(transaction: previewer.burgerKingTransaction)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
