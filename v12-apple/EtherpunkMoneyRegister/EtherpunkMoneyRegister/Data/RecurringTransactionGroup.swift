//
//  RecurringTransactionGroup.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class RecurringTransactionGroup {
    var name: String = ""
    var createdOn: Date = Date()

    @Relationship(deleteRule: .cascade)
    var recurringTransactions: [RecurringTransaction]?

    init(name: String, createdOn: Date = Date(), recurringTransactions: [RecurringTransaction]? = []) {
        self.name = name
        self.createdOn = createdOn
        self.recurringTransactions = recurringTransactions
    }
}
