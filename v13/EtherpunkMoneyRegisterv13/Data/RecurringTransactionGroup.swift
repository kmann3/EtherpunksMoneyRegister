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
    var id: UUID = UUID()
    var name: String = ""
    var createdOn: Date = Date()

    @Relationship(deleteRule: .cascade)
    var recurringTransactions: [RecurringTransaction]?

    init(id: UUID = UUID(), name: String, createdOn: Date = Date(), recurringTransactions: [RecurringTransaction]? = []) {
        self.id = id
        self.name = name
        self.createdOn = createdOn
        self.recurringTransactions = recurringTransactions
    }
}
