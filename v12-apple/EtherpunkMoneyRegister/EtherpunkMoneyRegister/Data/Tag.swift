//
//  Tag.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class Tag {
    var name: String

    @Relationship(deleteRule: .noAction, inverse: \AccountTransaction.tags)
    var transactions: [AccountTransaction]?

    var createdOn: Date

    @Relationship(deleteRule: .noAction, inverse: \RecurringTransaction.tags)
    var recurringTransaction: [RecurringTransaction]?

    init(name: String, transactions: [AccountTransaction]? = [], createdOn: Date = Date(), recurringTransaction: [RecurringTransaction]? = []) {
        self.name = name
        self.transactions = transactions
        self.createdOn = createdOn
        self.recurringTransaction = recurringTransaction
    }
}
