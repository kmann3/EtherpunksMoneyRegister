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
    var createdOn: Date = Date();
    
    @Relationship(deleteRule: .cascade)
    var recurringTransactions: [RecurringTransaction]? = nil
    
    init(name: String, createdOn: Date, recurringTransactions: [RecurringTransaction]? = nil) {
        self.name = name
        self.createdOn = createdOn
        self.recurringTransactions = recurringTransactions
    }
    
    init(name: String, recurringTransactions: [RecurringTransaction]? = nil) {
        self.name = name
        self.recurringTransactions = recurringTransactions
    }
}
