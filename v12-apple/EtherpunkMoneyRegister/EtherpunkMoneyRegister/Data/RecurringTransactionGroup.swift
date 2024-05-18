//
//  RecurringTransactionGroup.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
class RecurringTransactionGroup {
    var uuid: UUID = UUID.init()
    var name: String = ""
    var createdOn: Date = Date();
    
    @Relationship(deleteRule: .cascade)
    var recurringTransactions: [RecurringTransaction]? = nil
    
    init(uuid: UUID, name: String, createdOn: Date, recurringTransactions: [RecurringTransaction]? = nil) {
        self.uuid = uuid
        self.name = name
        self.createdOn = createdOn
        self.recurringTransactions = recurringTransactions
    }
}
