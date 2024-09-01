//
//  RecurringTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SQLite

final class RecurringTransaction : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var transactionType: TransactionType = TransactionType.debit
    public var amount: Decimal = 0
    public var notes: String = ""
    public var nextDueDate: Date? = nil
    public var transactionTags: [TransactionTag]? = nil
    public var recurringTransactionGroupId: UUID? = nil
    public var transactions: [AccountTransaction]? = nil
    public var frequency: RecurringFrequency = RecurringFrequency.unknown
    public var frequencyValue: Int? = nil
    public var frequencyDayOfWeek: DayOfWeek? = nil
    public var frequencyDateValue: Date? = nil
    public var createdOnLocal: Date {
        get {
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            if let utcDate = utcDateFormatter.date(from: _createdOnUTC) {
                // Convert UTC Date to local time Date
                let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                return Date(timeIntervalSinceReferenceDate: localTimeInterval)
            } else {
                debugPrint("Failed to convert UTC string to Date object.")
                return Date()
            }
        }
        set {
            // Convert local time to UTC
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            _createdOnUTC = utcDateFormatter.string(from: newValue)
        }
    }

    public var createdOnLocalString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            formatter.timeZone = .current
            return createdOnLocal.formatted()
        }
    }

    public var debugDescription: String {
            return """
            RecurringTransaction:
            -  id: \(id)
            -  name: \(name)
            -  transactionType: \(transactionType)
            -  amount: \(amount)
            -  notes: \(notes)
            -  dueDate: \(String(describing: nextDueDate))
            -  recurringTransactionGroupId: \(String(describing: recurringTransactionGroupId))
            -  frequency: \(frequency)
            -  frequencyValue: \(String(describing: frequencyValue))
            -  frequencyDayOfWeek: \(String(describing: frequencyDayOfWeek))
            -  frequencyDate: \(String(describing: frequencyDateValue))
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _createdOnUTC: String = ""

    private static let recurringTransactionSqlTable = Table("RecurringTransaction")
    private static let idColumn = Expression<String>("Id")
    private static let nameColumn = Expression<String>("Name")
    private static let transactionTypeColumn = Expression<String>("TransactionType")
    private static let amountColumn = Expression<Double?>("Amount")
    private static let notesColumn = Expression<String>("Notes")
    private static let nextDueDateColumn = Expression<String?>("NextDueDate")
    private static let recurringTransactionGroupIdColumn = Expression<String?>("RecurringTransactionGroupId")
    private static let frequecyColumn = Expression<String>("Frequecy")
    private static let frequencyValueColumn = Expression<String>("frequencyValue")
    private static let frequencyDayOfWeekColumn = Expression<String>("FrequencyDayOfWeek")
    private static let frequencyDateValueColumn = Expression<String>("FrequencyDateValue")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID = UUID(), name: String, transactionType: TransactionType, amount: Decimal, notes: String, nextDueDate: Date? = nil, transactionTags: [TransactionTag]? = [], recurringTransactionGroupId: UUID? = nil, transactions: [AccountTransaction]? = [], frequency: RecurringFrequency, frequencyValue: Int? = nil, frequencyDayOfWeek: DayOfWeek? = nil, frequencyDateValue: Date? = nil, createdOnLocal: Date = Date()) {
        self.id = id
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.notes = notes
        self.nextDueDate = nextDueDate
        self.transactionTags = transactionTags
        self.recurringTransactionGroupId = recurringTransactionGroupId
        self.transactions = transactions
        self.frequency = frequency
        self.frequencyValue = frequencyValue
        self.frequencyDayOfWeek = frequencyDayOfWeek
        self.frequencyDateValue = frequencyDateValue
        self.createdOnLocal = createdOnLocal

        self.VerifySignage()
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

    private func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }

    public static func createTable(appContainer: LocalAppStateContainer) {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            try db.run(recurringTransactionSqlTable.create { t in
                t.column(idColumn, primaryKey: true)
                t.column(nameColumn)
                t.column(transactionTypeColumn)
                t.column(amountColumn)
                t.column(notesColumn)
                t.column(nextDueDateColumn)
                t.column(recurringTransactionGroupIdColumn)
                t.column(frequecyColumn)
                t.column(frequencyValueColumn)
                t.column(frequencyDayOfWeekColumn)
                t.column(frequencyDateValueColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }
}
