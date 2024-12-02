//
//  RecurringTransactionGroup.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SQLite

final class RecurringTransactionGroup : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var recurringTransactions: [RecurringTransaction]?

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
            RecurringTransactionGroup:
            -  id: \(id)
            -  name: \(name)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _createdOnUTC: String = ""

    public typealias Expression = SQLite.Expression

    private static let recurringTransactionGroupSqlTable = Table("RecurringTransactionGroup")
    private static let idColumn = Expression<String>("Id")
    private static let nameColumn = Expression<String>("Name")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID = UUID(), name: String = "", createdOnLocal: Date = Date(), recurringTransactions: [RecurringTransaction]? = []) {
        self.id = id
        self.name = name
        self.recurringTransactions = recurringTransactions
        self.createdOnLocal = createdOnLocal
    }

    public static func createTable(appContainer: LocalAppStateContainer) {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            try db.run(recurringTransactionGroupSqlTable.create { t in
                t.column(idColumn, primaryKey: true)
                t.column(nameColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }
}