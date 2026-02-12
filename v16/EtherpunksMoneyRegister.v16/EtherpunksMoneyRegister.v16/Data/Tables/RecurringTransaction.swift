//
//  RecurringTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class RecurringTransaction: Identifiable, Hashable {
    @Attribute(.unique) public var id: String = UUID().uuidString
    public var name: String = ""
    public var transactionType: TransactionType {
        get { TransactionType(rawValue: transactionTypeRaw) ?? .debit }
        set { transactionTypeRaw = newValue.rawValue }
    }
    
    public var amount: Decimal = 0
    public var defaultAccount: Account
    public var defaultAccountId: String? = nil
    public var notes: String = ""
    public var isTaxRelated: Bool = false
    public var nextDueDate: Date? = nil
    @Relationship(deleteRule: .noAction, inverse: \TransactionTag.recurringTransactions) public var transactionTags: [TransactionTag]? = nil
    public var recurringGroupId: String? = nil
    @Relationship(deleteRule: .noAction, inverse: \RecurringGroup.recurringTransactions) public var recurringGroup: RecurringGroup? = nil
    public var transactions: [AccountTransaction]? = nil
    public var frequency: RecurringFrequency {
        get { RecurringFrequency(rawValue: frequencyRaw) ?? .unknown }
        set { frequencyRaw = newValue.rawValue }
    }
    public var frequencyValue: Int? = nil
    public var frequencyDayOfWeek: DayOfWeek? {
        get { frequencyDayOfWeekRaw.flatMap(DayOfWeek.init(rawValue:)) }
        set { frequencyDayOfWeekRaw = newValue?.rawValue }
    }
    public var frequencyDateValue: Date? = nil
    public var createdOnUTC: Date = Date()

    private var transactionTypeRaw: TransactionType.RawValue = TransactionType.debit.rawValue
    private var frequencyRaw: RecurringFrequency.RawValue = RecurringFrequency.unknown.rawValue
    private var frequencyDayOfWeekRaw: DayOfWeek.RawValue? = nil

    init(
        id: UUID = UUID(),
        name: String,
        transactionType: TransactionType = .debit,
        amount: Decimal = 0.0,
        defaultAccount: Account,
        notes: String = "",
        isTaxRelated: Bool = false,
        nextDueDate: Date? = nil,
        transactionTags: [TransactionTag]? = nil,
        recurringGroup: RecurringGroup? = nil,
        transactions: [AccountTransaction]? = nil,
        frequency: RecurringFrequency = .unknown,
        frequencyValue: Int? = nil,
        frequencyDayOfWeek: DayOfWeek? = nil,
        frequencyDateValue: Date? = nil
    ) {
        self.id = id.uuidString
        self.name = name
        self.amount = amount
        self.defaultAccount = defaultAccount
        self.defaultAccountId = defaultAccount.id
        self.notes = notes
        self.isTaxRelated = isTaxRelated
        self.nextDueDate = nextDueDate
        self.transactionTags = transactionTags
        self.recurringGroup = recurringGroup
        self.recurringGroupId = recurringGroup?.id ?? nil
        self.transactions = transactions
        self.frequency = frequency
        self.frequencyValue = frequencyValue
        self.frequencyDayOfWeek = frequencyDayOfWeek
        self.frequencyDateValue = frequencyDateValue

        self.transactionType = transactionType
        
        try! self.StartFirstDueDate()

        self.VerifySignage()
    }
    public static func transactionTypeFilter(type: TransactionType) -> Predicate<RecurringTransaction> {
        let rawValue = type.rawValue
        return #Predicate<RecurringTransaction> {
            $0.transactionTypeRaw == rawValue
        }
    }

    enum BumpDateError: Error {
        case missingFrequencyValue
        case missingNextDueDate
    }
    
    private func StartFirstDueDate()  throws {
        if self.nextDueDate != nil {
            return
        }
        
        switch self.frequency {
        case .unknown, .irregular:
            break
        case .yearly:
            // TBI
            break
        case .monthly:
            // TBI: Test what happens if the date is the 31's but next month has 28 or 30 days in it
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValue
            }
            self.nextDueDate = self.getNextDueDateMonthly(day: self.frequencyValue!)
        case .weekly:
            // TBI
            break
        case .xdays:
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValue
            }
            break
        case .xmonths:
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValue
            }
            break
        case .xweekOnYDayOfWeek:
            // TBI
            break
        }
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
                throw BumpDateError.missingFrequencyValue
            }
            self.nextDueDate = calendar.date(
                byAdding: .day, value: self.frequencyValue!,
                to: self.nextDueDate!)
        case .xmonths:
            if self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValue
            }
            self.nextDueDate = calendar.date(
                byAdding: .month, value: self.frequencyValue!,
                to: self.nextDueDate!)
        case .xweekOnYDayOfWeek:
            if self.frequencyDayOfWeek == nil || self.frequencyValue == nil {
                throw BumpDateError.missingFrequencyValue
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
    
    private func getNextDueDateXMonths(day: Int, months: Int) -> Date {
        return getNextDueDateMonthly(day: day, addMonths: months)
    }
    
    private func getNextDueDateMonthly(day: Int, addMonths: Int = 0) -> Date {
        let calendar = Calendar.current

        let currentComponents = calendar.dateComponents(
            [.year, .month, .day], from: Date())

        var monthsToAdd = 0

        if currentComponents.day! > 16 {
            monthsToAdd = 1
        }

        var components = calendar.dateComponents(
            [.year, .month, .day], from: Date())
        components.month! += monthsToAdd
        components.day = day

        let date = calendar.date(from: components)
        return date!
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

@MainActor
extension RecurringTransaction: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            RecurringTransaction:
            - id: \(id)
            - name: \(name)
            - default account: \(defaultAccount.name)
            - default account Id: \(String(describing: defaultAccountId))
            - transactionType: \(transactionType)
            - amount: \(amount)
            - notes: \(notes)
            - isTaxRelated: \(isTaxRelated)
            - nextDueDate: \(nextDueDate?.toDebugDate() ?? "nil")
            - recurringGroup: \(String(describing: recurringGroup))
            - frequency: \(frequency)
            - frequencyValue: \(String(describing: frequencyValue))
            - frequencyDayOfWeek: \(String(describing: frequencyDayOfWeek))
            - frequencyDate: \(String(describing: frequencyDateValue))
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }
}

