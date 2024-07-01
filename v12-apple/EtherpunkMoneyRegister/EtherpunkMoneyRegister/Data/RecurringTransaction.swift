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
    var id: UUID = UUID()
    var name: String = ""
    var transactionType: TransactionType = TransactionType.debit
    var amount: Decimal = 0
    var notes: String = ""
    var nextDueDate: Date? = nil

    @Relationship(deleteRule: .noAction)
    var transactionTags: [TransactionTag]? = nil

    var group: RecurringTransactionGroup? = nil

    @Relationship(deleteRule: .noAction)
    var transactions: [AccountTransaction]? = nil

    var frequency: RecurringFrequency = RecurringFrequency.unknown

    var frequencyValue: Int? = nil
    var frequencyDayOfWeek: DayOfWeek? = nil
    var frequencyDateValue: Date? = nil

    var createdOn: Date = Date()

    init(id: UUID = UUID(), name: String, transactionType: TransactionType, amount: Decimal, notes: String, nextDueDate: Date? = nil, transactionTags: [TransactionTag]? = [], group: RecurringTransactionGroup? = nil, transactions: [AccountTransaction]? = [], frequency: RecurringFrequency, frequencyValue: Int? = nil, frequencyDayOfWeek: DayOfWeek? = nil, frequencyDateValue: Date? = nil, createdOn: Date = Date()) {
        self.id = id
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.notes = notes
        self.nextDueDate = nextDueDate
        self.transactionTags = transactionTags
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
        case .unknown, .irregular:
            break
        case .yearly:
            self.nextDueDate = calendar.date(byAdding: .year, value: 1, to: self.nextDueDate!)
        case .monthly:
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
            if self.frequencyDayOfWeek == nil || self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValues
            }
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
