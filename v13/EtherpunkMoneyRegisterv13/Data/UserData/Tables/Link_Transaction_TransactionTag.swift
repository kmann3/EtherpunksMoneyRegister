//
//  Link_Transaction_TransactionTag.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/19/24.
//

import Foundation
import SQLite

final class Link_Transaction_TransactionTag : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var transactionId: UUID
    public var transactionTagId: UUID
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
            -  transactionId: \(transactionId)
            -  transactionTagId: \(transactionTagId)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _createdOnUTC: String = ""

    public typealias Expression = SQLite.Expression

    private static let link_Transaction_TransactionTag = Table("Link_Transaction_TransactionTag.swift")
    private static let transactionId = Expression<String>("transactionId")
    private static let transactionTagIdColumn = Expression<String>("transactionTagIdColumn")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(transactionId: UUID, transactionTagId: UUID, createdOnLocal: Date = Date()) {
        self.transactionId = transactionId
        self.transactionTagId = transactionTagId
        self.createdOnLocal = createdOnLocal
    }

    public static func createTable(appContainer: LocalAppStateContainer) {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            try db.run(link_Transaction_TransactionTag.create { t in
                t.column(transactionId)
                t.column(transactionTagIdColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }
}
