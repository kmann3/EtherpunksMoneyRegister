//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SQLite

final class Account : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var startingBalance: Decimal = 0
    public var currentBalance: Decimal = 0
    public var outstandingBalance: Decimal = 0
    public var outstandingItemCount: Int = 0
    public var notes: String = ""
    public var lastBalanced: Date = Date()
    public var sortIndex: Int = 255
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
            Account:
            -  id: \(id)
            -  name: \(name)
            -  startingBalance: \(startingBalance)
            -  currentBalance: \(currentBalance)
            -  outstandingItemCount: \(outstandingItemCount)
            -  notes: \(notes)
            -  lastBalanced: \(lastBalanced)
            -  sortIndex: \(sortIndex)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _createdOnUTC: String = ""

    private static let accountSqlTable = Table("Account")
    private static let idColumn = Expression<String>("Id")
    private static let nameColumn = Expression<String>("Name")
    private static let startingBalanceColumn = Expression<Double>("StartingBalance")
    private static let currentBalanceColumn = Expression<Double>("CurrentBalance")
    private static let outstandingItemCountColumn = Expression<Int64>("OutstandingItemCount")
    private static let notesColumn = Expression<String>("Notes")
    private static let lastBalancedColumn = Expression<String>("LastBalanced")
    private static let sortIndexColumn = Expression<Int64>("SortIndex")
    private static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID = UUID(), name: String, startingBalance: Decimal, currentBalance: Decimal, outstandingBalance: Decimal, outstandingItemCount: Int, notes: String, lastBalanced: Date = Date(), sortIndex: Int = 255, createdOnLocal: Date = Date(), transactions: [AccountTransaction]? = []) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.lastBalanced = lastBalanced
        self.sortIndex = sortIndex
        self.createdOnLocal = createdOnLocal
    }

    init(id: UUID = UUID(), name: String, startingBalance: Decimal, sortIndex: Int = 255) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = startingBalance
        self.outstandingBalance = 0
        self.outstandingItemCount = 0
        self.notes = ""
        self.lastBalanced = Date()
        self.sortIndex = sortIndex
        self.createdOnLocal = Date()
    }

    public static func createTable(appDbPath: String) {
        do {
            let db = try Connection(appDbPath)

            try db.run(accountSqlTable.create { t in
                t.column(idColumn, primaryKey: true)
                t.column(nameColumn)
                t.column(startingBalanceColumn)
                t.column(currentBalanceColumn)
                t.column(outstandingItemCountColumn)
                t.column(notesColumn)
                t.column(lastBalancedColumn)
                t.column(sortIndexColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint(error)
        }
    }

//    func update(isNew: Bool, name: String, startingBalance: Decimal, notes: String, modelContext: ModelContext) {
//        if startingBalance != self.startingBalance {
//            let difference: Decimal = self.startingBalance - startingBalance
//            self.currentBalance += difference
//            self.startingBalance = startingBalance
//            self.rebalance(amount: difference, modelContext: modelContext)
//        }
//
//        self.name = name
//        do {
//            if isNew {
//                modelContext.insert(self)
//            }
//            try modelContext.save()
//        } catch {
//            debugPrint("Error saving account: \(error)")
//        }
//    }
//
//    func rebalance(amount: Decimal, dateToBegin: Date? = nil, modelContext: ModelContext) {
//
//        if(self.transactionCount == 0) {
//            debugPrint("Empty")
//            return
//        }
//
//        debugdebugPrint("Begin predicate")
//
//        let accountId: UUID = self.id
//
//        var predicate: Predicate<AccountTransaction>
//
//        if let dateToBegin = dateToBegin {
//            // We probably either adjusted the amount of an older transaction or moved one transaction to a new account
//            predicate = #Predicate<AccountTransaction> { transaction in
//                transaction.accountId == accountId && transaction.createdOn >= dateToBegin
//            }
//        } else {
//            // We probably changed the starting balance and need to readjust all transactions
//            predicate = #Predicate<AccountTransaction> { transaction in
//                transaction.accountId == accountId
//            }
//        }
//
//        let fetchDescriptor = FetchDescriptor<AccountTransaction>(predicate: predicate)
//
//        do {
//            let newTransactions = try modelContext.fetch(fetchDescriptor)
//            debugdebugPrint("Begin loop")
//            for transaction in newTransactions {
//                debugdebugPrint("Transaction: \(transaction.name)")
//                transaction.balance += amount
//            }
//            try modelContext.save()
//        } catch {
//            DispatchQueue.main.async {
//                debugPrint("Error fetching transactions: \(error.localizedDescription)")
//            }
//        }
//
//    }
}
