//
//  AccountTransactionFile.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/30/24.
//

import Foundation
import SQLite

final class TransactionFile : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var filename: String = ""
    public var notes: String = ""
    public var data: SQLite.Blob
    public var isTaxRelated: Bool = false
    public var transactionId: UUID

    // other types of files?
    // Account - contracts, opening papers, statements
    // Recurring Transactions - contracts

    // Files might also have different tags such as: receipt, documentation, confirmation

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
            TransactionFile:
            -  id: \(id)
            -  name: \(name)
            -  fileName: \(filename)
            -  notes: \(notes)
            -  data size in bytes: \(data.bytes.count)
            -  isTaxRelated: \(isTaxRelated)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _createdOnUTC: String = ""

    private static let transactionFileSqlTable = Table("TransactionFile")
    private static let idColumn = Expression<String>("Id")
    private static let nameColumn = Expression<String>("Name")
    private static let fileNameColumn = Expression<String>("FileName")
    private static let notesColumn = Expression<String>("Notes")
    private static let transactionId = Expression<String>("TransactionId")
    private static let isTaxRelated = Expression<Int64>("IsTaxRelated")
    private static let dataColumn = Expression<SQLite.Blob>("Data")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID = UUID(), name: String = "", filename: String = "", notes: String = "", data: SQLite.Blob, isTaxRelated: Bool = false, transactionId: UUID, createdOnLocal: Date = Date()) {
        self.id = id
        self.name = name
        self.filename = filename
        self.notes = notes
        self.data = data
        self.transactionId = transactionId
        self.isTaxRelated = isTaxRelated
        self.createdOnLocal = createdOnLocal
    }

    public static func createTable(appDbPath: String) {
        do {
            let db = try Connection(appDbPath)

            try db.run(transactionFileSqlTable.create { t in
                t.column(idColumn, primaryKey: true)
                t.column(nameColumn)
                t.column(fileNameColumn)
                t.column(notesColumn)
                t.column(transactionId)
                t.column(isTaxRelated)
                t.column(dataColumn)
                t.column(dataColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }
}
