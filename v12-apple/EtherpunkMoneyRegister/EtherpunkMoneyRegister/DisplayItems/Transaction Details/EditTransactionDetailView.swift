//
//  EditTransactionDetailView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import SwiftUI

struct EditTransactionDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    @Binding var doSave: Bool
    @Bindable var transaction: AccountTransaction
    
    private var title: String {
        transaction.name == "" ? "Add Transaction" : "Edit \(transaction.name)"
    }
    
    init(path: Binding<NavigationPath>, doSave: Binding<Bool>, transaction: AccountTransaction) {
        self._path = path
        self._doSave = doSave
        self.transaction = transaction
    }
    
    // IF IT IS A NEW CONNECTION TRY AND SNAG LOCATION TO INFER THE NAME?
    var body: some View {
        Text("Edit Transaction")
        Text("Name: \(transaction.name)")
        Text("Id: \(transaction.id)")

    }
}

#Preview {
    do {
        
        let previewer = try Previewer()
        let doSave: Bool = false
        return EditTransactionDetailView(path: .constant(NavigationPath()), doSave: .constant(doSave),  transaction: previewer.burgerKingTransaction)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
