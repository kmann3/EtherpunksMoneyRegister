//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftData

@Model
final class Account {
    @Attribute(.unique) var name: String
    var startingBalance: Decimal = 0
    var currentBalance: Decimal
    var outstandingBalance: Decimal = 0
    var outstandingItemCount: Int = 0
    var notes: String = ""
    var lastBalanced: Date = Date()
    var sortIndex: Int = 255
    
    var createdOn: Date = Date()
    
    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account)
    var transactions: [AccountTransaction]? = nil
    
    init(name: String, startingBalance: Decimal, currentBalance: Decimal, outstandingBalance: Decimal, outstandingItemCount: Int, notes: String, createdOn: Date, transactions: [AccountTransaction]? = nil, sortIndex: Int = 255) {
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.createdOn = createdOn
        self.transactions = transactions
        self.sortIndex = sortIndex
    }
    
    init(name: String, startingBalance: Decimal) {
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = startingBalance
    }
}
