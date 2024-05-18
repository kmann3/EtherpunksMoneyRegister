//
//  RecurringTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
class RecurringTransaction {
    var uuid: UUID = UUID.init()
    var name: String = ""
    var transactionType: TransactionType = TransactionType.Debit
    var amount: Decimal = 0
    var notes: String = ""
    
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]?
    
    var group: RecurringTransactionGroup?
    
    @Relationship(deleteRule: .noAction)
    var transactions: [AccountTransaction]?
    
    var frequency: RecurringFrequency = RecurringFrequency.unknown
    
    var frequencyValue: Int? = nil
    // day of week
    var frequencyDateValue: Date? = nil
    
    var createdOn: Date = Date()
    
    init(uuid: UUID, name: String, transactionType: TransactionType, amount: Decimal, notes: String, tags: [Tag]? = nil, group: RecurringTransactionGroup? = nil, transactions: [AccountTransaction]? = nil, frequency: RecurringFrequency, frequencyValue: Int? = nil, frequencyDateValue: Date? = nil, createdOn: Date) {
        self.uuid = uuid
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.notes = notes
        self.tags = tags
        self.group = group
        self.transactions = transactions
        self.frequency = frequency
        self.frequencyValue = frequencyValue
        self.frequencyDateValue = frequencyDateValue
        self.createdOn = createdOn
    }
}
