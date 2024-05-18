//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftData

@Model
class Account {
    var id: UUID = UUID.init()
    var name: String
    var startingBalance: Decimal = 0
    var currentBalance: Decimal
    var outstandingBalance: Decimal = 0
    var outstandingItemCount: Int = 0
    var notes: String = ""
    var lastBalanced: Date = Date()
    
    var createdOn: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account)
    var transactions: [AccountTransaction]? = nil
    
    init(id: UUID, name: String, startingBalance: Decimal, currentBalance: Decimal, outstandingBalance: Decimal, outstandingItemCount: Int, notes: String, createdOn: Date, transactions: [AccountTransaction]? = nil) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.createdOn = createdOn
        self.transactions = transactions
    }
    
    init(name: String, startingBalance: Decimal) {
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = startingBalance
    }
}
