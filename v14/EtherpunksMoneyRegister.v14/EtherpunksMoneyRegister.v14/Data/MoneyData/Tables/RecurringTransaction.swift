//
//  RecurringTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class RecurringTransaction: ObservableObject, CustomDebugStringConvertible, Identifiable, Hashable {
    @Attribute(.unique) public var id: UUID = UUID()
    public var name: String = ""
    public var transactionType: TransactionType = TransactionType.debit
    public var amount: Decimal = 0
    public var notes: String = ""
    public var nextDueDate: Date? = nil
    @Relationship(deleteRule: .noAction) public var transactionTags: [TransactionTag]? = nil
    public var recurringGroupId: UUID? = nil
    @Relationship(deleteRule: .noAction, inverse: \RecurringGroup.recurringTransactions) public var recurringGroup: RecurringGroup? = nil
    public var transactions: [AccountTransaction]? = nil
    public var frequency: RecurringFrequency = RecurringFrequency.unknown
    public var frequencyValue: Int? = nil
    public var frequencyDayOfWeek: DayOfWeek? = nil
    public var frequencyDateValue: Date? = nil
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
        return """
            RecurringTransaction:
            - id: \(id)
            - name: \(name)
            - transactionType: \(transactionType)
            - amount: \(amount)
            - notes: \(notes)
            - dueDate: \(nextDueDate?.toDebugDate() ?? "nil")
            - recurringGroup: \(String(describing: recurringGroup))
            - frequency: \(frequency)
            - frequencyValue: \(String(describing: frequencyValue))
            - frequencyDayOfWeek: \(String(describing: frequencyDayOfWeek))
            - frequencyDate: \(String(describing: frequencyDateValue))
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }

    init(
        id: UUID = UUID(),
        name: String,
        transactionType: TransactionType = .debit,
        amount: Decimal = 0.0,
        notes: String = "",
        nextDueDate: Date? = nil,
        transactionTags: [TransactionTag]? = nil,
        recurringGroup: RecurringGroup? = nil,
        transactions: [AccountTransaction]? = nil,
        frequency: RecurringFrequency = .unknown,
        frequencyValue: Int? = nil,
        frequencyDayOfWeek: DayOfWeek? = nil,
        frequencyDateValue: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.notes = notes
        self.nextDueDate = nextDueDate
        self.transactionTags = transactionTags
        self.recurringGroup = recurringGroup
        self.recurringGroupId = recurringGroup?.id ?? nil
        self.transactions = transactions
        self.frequency = frequency
        self.frequencyValue = frequencyValue
        self.frequencyDayOfWeek = frequencyDayOfWeek
        self.frequencyDateValue = frequencyDateValue
    }

    enum BumpDateError: Error {
        case missingFrequencyValues
        case missingNextDueDate
    }

    public func BumpNextDueDate() throws {
        if self.nextDueDate == nil {
            throw BumpDateError.missingNextDueDate
        }

        let calendar = Calendar.current

        switch self.frequency {
        case .unknown, .irregular:
            break
        case .yearly:
            self.nextDueDate = calendar.date(
                byAdding: .year, value: 1, to: self.nextDueDate!)
        case .monthly:
            // TBI: Test what happens if the date is the 31's but next month has 28 or 30 days in it
            self.nextDueDate = calendar.date(
                byAdding: .month, value: 1, to: self.nextDueDate!)
        case .weekly:
            self.nextDueDate = calendar.date(
                byAdding: .day, value: 7, to: self.nextDueDate!)
        case .xdays:
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValues
            }
            self.nextDueDate = calendar.date(
                byAdding: .day, value: self.frequencyValue!,
                to: self.nextDueDate!)
        case .xmonths:
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValues
            }
            self.nextDueDate = calendar.date(
                byAdding: .month, value: self.frequencyValue!,
                to: self.nextDueDate!)
        case .xweekOnYDayOfWeek:
            if self.frequencyDayOfWeek == nil || self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValues
            }
            let nextMonth = calendar.date(
                byAdding: .month, value: 1, to: self.nextDueDate!)
            let currentComponents = calendar.dateComponents(
                [.year, .month], from: nextMonth!)
            let startOfMonth = calendar.date(from: currentComponents)
            let startWeekday = calendar.component(.weekday, from: startOfMonth!)
            var difference =
                (self.frequencyDayOfWeek!.rawValue - startWeekday + 7) % 7
            difference += (self.frequencyValue! - 1) * 7
            self.nextDueDate = calendar.date(
                byAdding: .day, value: difference, to: startOfMonth!)
        }
    }

    private func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }
}
