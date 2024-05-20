//
//  TransactionListView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//
import SwiftData
import SwiftUI

struct TransactionListView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\AccountTransaction.createdOn, order: .reverse)])
    var items: [AccountTransaction]
    
    var body: some View {
        NavigationStack() {
            List(items) { item in
                    TransactionListItemView(item: TransactionListItem(transaction: item))
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionListView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
