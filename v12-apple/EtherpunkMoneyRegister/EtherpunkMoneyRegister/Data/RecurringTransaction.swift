//
//  RecurringTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class RecurringTransaction {
    var name: String = ""
    var transactionType: TransactionType = TransactionType.debit
    var amount: Decimal = 0
    var notes: String = ""
    var nextDueDate: Date?
    
    @Relationship(deleteRule: .noAction)
    var tags: [Tag]?
    
    var group: RecurringTransactionGroup?
    
    @Relationship(deleteRule: .noAction)
    var transactions: [AccountTransaction]?
    
    var frequency: RecurringFrequency = RecurringFrequency.unknown
    
    var frequencyValue: Int?
    var frequencyDayOfWeek: DayOfWeek?
    var frequencyDateValue: Date?
    
    var createdOn: Date = Date()

    init(name: String, transactionType: TransactionType, amount: Decimal, notes: String, nextDueDate: Date? = nil, tags: [Tag]? = [], group: RecurringTransactionGroup? = nil, transactions: [AccountTransaction]? = [], frequency: RecurringFrequency, frequencyValue: Int? = nil, frequencyDayOfWeek: DayOfWeek? = nil, frequencyDateValue: Date? = nil, createdOn: Date) {
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.notes = notes
        self.nextDueDate = nextDueDate
        self.tags = tags
        self.group = group
        self.transactions = transactions
        self.frequency = frequency
        self.frequencyValue = frequencyValue
        self.frequencyDayOfWeek = frequencyDayOfWeek
        self.frequencyDateValue = frequencyDateValue
        self.createdOn = createdOn
        
        self.VerifySignage()
    }
    
    enum BumpDateError: Error {
        case missingFrequencyValues
        case missingNextDueDate
    }
    
    func BumpNextDueDate() throws {
        if self.nextDueDate == nil {
            throw BumpDateError.missingNextDueDate
        }
        
        let calendar = Calendar.current
        
        switch self.frequency {
        case .unknown:
            break
            
        case .irregular:
            break
            
        case .yearly:
            self.nextDueDate = calendar.date(byAdding: .year, value: 1, to: self.nextDueDate!)
            
        case .monthly:
            // what if it ends on a holiday or a weekend
            self.nextDueDate = calendar.date(byAdding: .month, value: 1, to: self.nextDueDate!)

        case .weekly:
            self.nextDueDate = calendar.date(byAdding: .day, value: 7, to: self.nextDueDate!)
            
        case .xdays:
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValues
            }
            
            self.nextDueDate = calendar.date(byAdding: .day, value: self.frequencyValue!, to: self.nextDueDate!)
            
        case .xmonths:
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValues
            }
            
            self.nextDueDate = calendar.date(byAdding: .month, value: self.frequencyValue!, to: self.nextDueDate!)
            
        case .xweekOnYDayOfWeek:
            let nextMonth = calendar.date(byAdding: .month, value: 1, to: self.nextDueDate!)

            let currentComponents = calendar.dateComponents([.year, .month], from: nextMonth!)

            let startOfMonth = calendar.date(from: currentComponents)

            let startWeekday = calendar.component(.weekday, from: startOfMonth!)

            var difference = (self.frequencyDayOfWeek!.rawValue - startWeekday + 7) % 7

            difference += (self.frequencyValue! - 1) * 7

            self.nextDueDate = calendar.date(byAdding: .day, value: difference, to: startOfMonth!)
        }
    }
    
    func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
            
        case .debit:
            self.amount = -abs(self.amount)
        }
    }
}
