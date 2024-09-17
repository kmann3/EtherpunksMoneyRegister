//
//  AccountTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SQLite
import SwiftUI

final class AccountTransaction : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var transactionType: TransactionType = TransactionType.debit
    public var amount: Decimal = 0
    public var balance: Decimal? = nil

    public var pendingLocal: Date? {
        get {
            if _pendingDateUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _pendingDateUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _pendingDateUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _pendingDateUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var pendingLocalString: String {
        get {
            if pendingLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return pendingLocal!.formatted()
            }
        }
    }

    public var clearedLocal: Date? {
        get {
            if _clearedDateUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _clearedDateUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _clearedDateUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _clearedDateUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var clearedLocalString: String {
        get {
            if clearedLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return clearedLocal!.formatted()
            }
        }
    }

    public var notes: String = ""
    public var confirmationNumber: String = ""
    public var recurringTransactionId: UUID? = nil
    public var dueDate: Date? = nil
    public var dueDateLocal: Date? {
        get {
            if _dueDateUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _dueDateUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _dueDateUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _dueDateUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var dueDateLocalString: String {
        get {
            if dueDateLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return dueDateLocal!.formatted()
            }
        }
    }

    public var isTaxRelated: Bool = false
    public var files: [TransactionFile]? = nil
    public var filesCount: Int = 0
    public var accountId: UUID
    public var transactionTags: [TransactionTag]? = nil
    public var balancedOnLocal: Date? {
        get {
            if _balancedOnUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _balancedOnUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _balancedOnUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _balancedOnUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var balancedOnLocalString: String {
        get {
            if balancedOnLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return balancedOnLocal!.formatted()
            }
        }
    }

    /// The background color indicating the status of the transaction.
    public var backgroundColor: Color {
        switch self.transactionStatus {
        case .cleared:
            Color.clear
        case .pending:
            Color(.sRGB, red: 255/255, green: 150/255, blue: 25/255, opacity: 0.5)
        case .reserved:
            Color(.sRGB, red: 255/255, green: 25/255, blue: 25/255, opacity: 0.5)
        }
    }

    /// The inferred status of the transaction.
    public var transactionStatus: TransactionStatus {
        if self.pendingLocal == nil && self.clearedLocal == nil {
            return .reserved
        } else if self.pendingLocal != nil && self.clearedLocal == nil {
            return .pending
        } else {
            return .cleared
        }
    }

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
            AccountTransaction:
            -  id: \(id)
            -  accountId: \(accountId)
            -  name: \(name)
            -  transactionType: \(transactionType)
            -  amount: \(amount)
            -  balance: \(String(describing: balance))
            -  pendingUTC: \(String(describing: _pendingDateUTC))
            -  pendingLocal: \(pendingLocalString)
            -  name: \(name)
            -  name: \(name)
            -  notes: \(notes)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _pendingDateUTC: String? = ""
    private var _clearedDateUTC: String? = ""
    private var _dueDateUTC: String? = ""
    private var _balancedOnUTC: String? = ""
    private var _createdOnUTC: String = ""

    public typealias Expression = SQLite.Expression

    private static let accountTransactionSqlTable = Table("AccountTransaction")
    private static let idColumn = Expression<String>("Id")
    private static let accountIdColumn = Expression<String>("AccountId")
    private static let nameColumn = Expression<String>("Name")
    private static let transactionTypeColumn = Expression<String>("TransactionType")
    private static let amountColumn = Expression<Double>("Amount")
    private static let balanceColumn = Expression<Double?>("Balance")
    private static let pendingUTCColumn = Expression<String?>("PendingDateUTC")
    private static let clearedUTCColumn = Expression<String?>("ClearedDateUTC")
    private static let recurringTransactionIdColumn = Expression<String?>("RecurringTransactionId")
    private static let notesColumn = Expression<String>("Notes")
    private static let confirmationColumn = Expression<String>("ConfirmationNumber")
    private static let isTaxRelatedColumn = Expression<Bool>("IsTaxRelated")
    private static let dueDateUTCColumn = Expression<String?>("DueDate")
    private static let balancedOnUTCColumn = Expression<String?>("BalancedOnUTC")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID = UUID(), accountId: UUID, name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal? = nil, pendingLocal: Date? = nil, clearedLocal: Date? = nil, notes: String = "", confirmationNumber: String = "", recurringTransactionId: UUID? = nil, files: [TransactionFile]? = [], transactionTags: [TransactionTag]? = [], isTaxRelated: Bool = false, dueDateLocal: Date? = nil, balancedOnLocal: Date? = nil, createdOnLocal: Date = Date()) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pendingLocal = pendingLocal
        self.clearedLocal = clearedLocal
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.recurringTransactionId = recurringTransactionId
        self.dueDateLocal = dueDateLocal
        self.isTaxRelated = isTaxRelated
        self.files = files
        self.transactionTags = transactionTags
        self.balancedOnLocal = balancedOnLocal
        self.createdOnLocal = createdOnLocal

        self.VerifySignage()
    }

    init(id: UUID = UUID(), accountId: UUID, name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal? = nil, pendingUTC: String? = nil, clearedUTC: String? = nil, notes: String = "", confirmationNumber: String = "", recurringTransactionId: String? = nil, files: [TransactionFile]? = [], transactionTags: [TransactionTag]? = [], isTaxRelated: Bool = false, dueDateUTC: String?, balancedOnUTC: String?, createdOnUTC: String) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self._pendingDateUTC = pendingUTC
        self._clearedDateUTC = clearedUTC
        self.notes = notes
        self.confirmationNumber = confirmationNumber

        var recTranId: String?  = recurringTransactionId
        var recTranIdUUID: UUID? = nil
        if recTranId != nil {
            recTranIdUUID = UUID.init(uuidString: recurringTransactionId!)
        }

        self.recurringTransactionId = recTranIdUUID
        self._dueDateUTC = dueDateUTC
        self.isTaxRelated = isTaxRelated
        self.files = files
        self.transactionTags = transactionTags
        self._balancedOnUTC = balancedOnUTC
        self._createdOnUTC = createdOnUTC

        self.VerifySignage()
    }

    func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }

    public func fillFiles(appContainer: LocalAppStateContainer) {
        
    }

    public func fillFileCountAndTags(appContainer: LocalAppStateContainer) {
        self.transactionTags = nil
        self.filesCount = 0
    }

    public static func createTable(appContainer: LocalAppStateContainer) {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            try db.run(accountTransactionSqlTable.create { t in
                t.column(idColumn, primaryKey: true)
                t.column(accountIdColumn)
                t.column(nameColumn)
                t.column(transactionTypeColumn)
                t.column(amountColumn)
                t.column(balanceColumn)
                t.column(pendingUTCColumn)
                t.column(clearedUTCColumn)
                t.column(recurringTransactionIdColumn)
                t.column(notesColumn)
                t.column(confirmationColumn)
                t.column(isTaxRelatedColumn)
                t.column(dueDateUTCColumn)
                t.column(balancedOnUTCColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }

    public static func getTransactions(appContainer: LocalAppStateContainer, currentPage: Int = 0) -> [AccountTransaction] {
        var returnList: [AccountTransaction] = []

        return []
    }


    public static func convertEntryToAccountTransaction(appContainer: LocalAppStateContainer ,entry: Row) -> AccountTransaction? {
        do {
            var returnTransaction: AccountTransaction? = nil
//            var returnTransaction: AccountTransaction = try AccountTransaction(id: UUID.init(uuidString: entry.get(AccountTransaction.idColumn))!,
//                                                                               accountId: UUID.init(uuidString: entry.get(AccountTransaction.accountIdColumn))!,
//                                                                               name: entry[AccountTransaction.nameColumn],
//                                                                               transactionType: <#T##TransactionType#>,
//                                                                               amount: entry.get(AccountTransaction.amountColumn).toDecimal(),
//                                                                               balance: <#T##Decimal?#>,
//                                                                               pendingUTC: entry.get(AccountTransaction.pendingUTCColumn),
//                                                                               clearedUTC: entry.get(AccountTransaction.clearedUTCColumn),
//                                                                               notes: entry.get(AccountTransaction.notesColumn),
//                                                                               confirmationNumber: entry.get(AccountTransaction.confirmationColumn),
//                                                                               recurringTransactionId: entry.get(AccountTransaction.recurringTransactionIdColumn),
//                                                                               files: nil,
//                                                                               transactionTags: nil,
//                                                                               isTaxRelated: entry.get(AccountTransaction.isTaxRelatedColumn),
//                                                                               dueDateUTC: entry.get(AccountTransaction.dueDateUTCColumn),
//                                                                               balancedOnUTC: entry.get(AccountTransaction.balancedOnUTCColumn),
//                                                                               createdOnUTC: entry.get(AccountTransaction.createdOnUTCColumn))
//
//            returnTransaction.fillFileCountAndTags(appContainer: appContainer)
            return returnTransaction
        } catch {
            debugPrint("Error: \(error)")
            return nil
        }
    }
}
