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
    var items: [TransactionListItem]
    
    var body: some View {
        NavigationStack() {
            List {
                VStack() {
                    Text("Date")
                }
            }
        }
    }
}

//#Preview {
//    TransactionListView()
//}
