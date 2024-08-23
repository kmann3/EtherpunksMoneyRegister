//
//  Link_RecurringTransaction_RecurringTransactionTag.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/19/24.
//

import Foundation
import SQLite

final class Link_RecurringTransaction_RecurringTransactionTag : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var recurringTransactionId: UUID
    public var recurringTransactionTagId: UUID
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
            RecurringTransactionTag:
            -  recurringTransactionId: \(recurringTransactionId)
            -  recurringTransactionTagId: \(recurringTransactionTagId)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _createdOnUTC: String = ""

    private static let link_RecurringTransaction_RecurringTransactionTag = Table("Link_RecurringTransaction_RecurringTransactionTag.swift")
    private static let recurringTransactionId = Expression<String>("recurringTransactionId")
    private static let recurringTransactionTagIdColumn = Expression<String>("recurringTransactionTagId")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(recurringTransactionId: UUID, recurringTransactionTagId: UUID, createdOnLocal: Date = Date()) {
        self.recurringTransactionId = recurringTransactionId
        self.recurringTransactionTagId = recurringTransactionTagId
        self.createdOnLocal = createdOnLocal
    }

    public static func createTable(appContainer: LocalAppStateContainer) {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            try db.run(link_RecurringTransaction_RecurringTransactionTag.create { t in
                t.column(recurringTransactionId)
                t.column(recurringTransactionTagIdColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }
}
