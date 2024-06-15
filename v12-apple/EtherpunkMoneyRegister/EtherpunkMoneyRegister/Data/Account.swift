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
    var id: UUID
    var name: String
    var startingBalance: Decimal
    var currentBalance: Decimal
    var outstandingBalance: Decimal
    var outstandingItemCount: Int
    var notes: String
    var lastBalanced: Date
    var sortIndex: Int
    var createdOn: Date

    @Relationship(deleteRule: .cascade, inverse: \AccountTransaction.account)
    var transactions: [AccountTransaction]?

    init(id: UUID = UUID(), name: String, startingBalance: Decimal, currentBalance: Decimal, outstandingBalance: Decimal, outstandingItemCount: Int, notes: String, lastBalanced: Date = Date(), sortIndex: Int = 255, createdOn: Date = Date(), transactions: [AccountTransaction]? = []) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.lastBalanced = lastBalanced
        self.sortIndex = sortIndex
        self.createdOn = createdOn
        self.transactions = transactions
    }

    init(id: UUID = UUID(), name: String, startingBalance: Decimal, sortIndex: Int = 255) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = startingBalance
        self.outstandingBalance = 0
        self.outstandingItemCount = 0
        self.notes = ""
        self.lastBalanced = Date()
        self.sortIndex = sortIndex
        self.createdOn = Date()
        self.transactions = []
    }
}
