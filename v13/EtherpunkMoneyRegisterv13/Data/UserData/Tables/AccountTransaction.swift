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
    public var pending: Date? = nil
    public var cleared: Date? = nil
    public var notes: String = ""
    public var confirmationNumber: String = ""
    public var recurringTransaction: RecurringTransaction? = nil
    public var dueDate: Date? = nil
    public var isTaxRelated: Bool = false
    public var files: [TransactionFile]? = nil
    public var account: Account? = nil
    public var accountId: UUID? = nil
    public var transactionTags: [TransactionTag]? = nil
    public var balancedOn: Date? = nil

    /// The amount of files associated with the transaction.
    public var fileCount: Int {
        self.files?.count ?? 0
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
        if self.pending == nil && self.cleared == nil {
            return .reserved
        } else if self.pending != nil && self.cleared == nil {
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
            -  name: \(name)
            -  notes: \(notes)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _createdOnUTC: String = ""

    private static let accountTransactionSqlTable = Table("AccountTransaction")
    private static let idColumn = Expression<String>("Id")
    private static let accountIdColumn = Expression<String>("AccountId")
    private static let nameColumn = Expression<String>("Name")
    private static let transactionTypeColumn = Expression<String>("TransactionType")
    private static let amountColumn = Expression<Double>("Amount")
    private static let balanceColumn = Expression<Double?>("Balance")
    private static let pendingColumn = Expression<String?>("PendingDate")
    private static let clearedColumn = Expression<String?>("ClearedDate")
    private static let notesColumn = Expression<String>("Notes")
    private static let confirmationColumn = Expression<String>("ConfirmationNumber")
    private static let isTaxRelatedColumn = Expression<Bool>("IsTaxRelated")
    private static let dueDateColumn = Expression<String?>("DueDate")
    private static let balancedOnColumn = Expression<String?>("BalancedOn")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID = UUID(), account: Account, name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal? = nil, pending: Date? = nil, cleared: Date? = nil, notes: String = "", confirmationNumber: String = "", recurringTransaction: RecurringTransaction? = nil, files: [TransactionFile]? = [], transactionTags: [TransactionTag]? = [], isTaxRelated: Bool = false, dueDate: Date? = nil, balancedOn: Date? = nil, createdOnLocal: Date = Date()) {
        self.id = id
        self.account = account
        self.accountId = account.id
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pending = pending
        self.cleared = cleared
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.recurringTransaction = recurringTransaction
        self.dueDate = dueDate
        self.isTaxRelated = isTaxRelated
        self.files = files
        self.transactionTags = transactionTags
        self.balancedOn = balancedOn
        self.createdOnLocal = createdOnLocal

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
                t.column(pendingColumn)
                t.column(clearedColumn)
                t.column(notesColumn)
                t.column(confirmationColumn)
                t.column(isTaxRelatedColumn)
                t.column(dueDateColumn)
                t.column(balancedOnColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }

    public func getTransactions(appContainer: LocalAppStateContainer, currentPage: Int = 0) -> [AccountTransaction] {

        return []
    }

//    func SaveTransaction(modelContext: ModelContext, transaction: AccountTransaction, name: String, amount: Decimal) {
//        transaction.name = name
//
//        try? modelContext.save()
//
//        // perhaps we open with async stuff and return the transaction?
//    }
//
//    func getFileCount(modelContext: ModelContext) -> Int {
//
//        let descriptor = FetchDescriptor<TransactionFile>(predicate: #Predicate { $0.transactionId! == self.id })
//
//        return (try? modelContext.fetchCount(descriptor)) ?? 0
//    }
}
