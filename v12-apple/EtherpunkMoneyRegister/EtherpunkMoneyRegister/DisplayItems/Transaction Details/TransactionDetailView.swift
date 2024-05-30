//
//  TransactionDetailView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import SwiftUI

struct TransactionDetailView: View {
    @Binding var path: NavigationPath
    @Bindable var transaction: AccountTransaction
    
    var body: some View {
        Text("Transaction Details")
        Text("Name: \(transaction.name)")
        Text("Id: \(transaction.id)")
        
        .toolbar {
            Button {
                path.append(NavData(navView: .editTransaction, transaction: transaction))
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionDetailView(path:  .constant(NavigationPath()), transaction: previewer.burgerKingTransaction)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
