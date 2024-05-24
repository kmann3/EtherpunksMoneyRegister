//
//  TransactionDetailView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/22/24.
//

import SwiftUI

struct TransactionDetailView: View {
    var transaction: AccountTransaction
    
    var body: some View {
        Text("Transaction Details")
        Text("Name: \(transaction.name)")
        Text("Id: \(transaction.id)")
    }
}
