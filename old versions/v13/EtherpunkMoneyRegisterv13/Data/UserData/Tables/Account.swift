//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SQLite

final class Account: ObservableObject, CustomDebugStringConvertible, Identifiable {
    public var id: UUID = .init()
    public var name: String = ""
    public var startingBalance: Decimal = 0
    public var currentBalance: Decimal = 0
    public var outstandingBalance: Decimal = 0
    public var outstandingItemCount: Int64 = 0
    public var notes: String = ""

    public var lastBalancedLocal: Date {
        get {
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            if let utcDate = utcDateFormatter.date(from: _lastBalancedUTC) {
                // Convert UTC Date to local time Date
                let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                return Date(timeIntervalSinceReferenceDate: localTimeInterval)
            } else {
                debugPrint("lastBalancedLocal: Failed to convert UTC string to Date object.")
                return Date()
            }
        }
        set {
            // Convert local time to UTC
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            _lastBalancedUTC = utcDateFormatter.string(from: newValue)
        }
    }

    public var lastBalancedLocalString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = .current
        return lastBalancedLocal.formatted()
    }

    public var sortIndex: Int64 = .max
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
                debugPrint("createdOnLocal: Failed to convert UTC string to Date object.")
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = .current
        return createdOnLocal.formatted()
    }

    public var debugDescription: String {
        return """
        Account:
        -  id: \(id)
        -  name: \(name)
        -  startingBalance: \(startingBalance)
        -  currentBalance: \(currentBalance)
        -  oustandingBalance: \(outstandingBalance)
        -  outstandingItemCount: \(outstandingItemCount)
        -  notes: \(notes)
        -  lastBalancedLocal: \(lastBalancedLocal)
        -  lastBalancedLocalString: \(lastBalancedLocalString)
        -  _lastBalancedUTC: \(_lastBalancedUTC)
        -  sortIndex: \(sortIndex)
        -  createdOnLocal: \(createdOnLocal)
        -  createdOnLocalString: \(createdOnLocalString)
        -  _createdOnUTC: \(_createdOnUTC)
        """
    }

    private var _createdOnUTC: String = ""
    private var _lastBalancedUTC: String = ""

    public typealias Expression = SQLite.Expression

    public static let accountSqlTable = Table("Account")
    public static let idColumn = Expression<String>("Id")
    public static let nameColumn = Expression<String>("Name")
    public static let startingBalanceColumn = Expression<Double>("StartingBalance")
    public static let currentBalanceColumn = Expression<Double>("CurrentBalance")
    public static let oustandingBalanceColumn = Expression<Double>("OustandingBalance")
    public static let outstandingItemCountColumn = Expression<Int64>("OutstandingItemCount")
    public static let notesColumn = Expression<String>("Notes")
    public static let lastBalancedUTCColumn = Expression<String>("LastBalancedUTC")
    public static let sortIndexColumn = Expression<Int64>("SortIndex")
    public static let createdOnUTCColumn = Expression<String>("CreatedOnUTC")

    init(id: UUID = UUID(), name: String, startingBalance: Decimal = 0, currentBalance: Decimal, outstandingBalance: Decimal = 0, outstandingItemCount: Int64 = 0, notes: String = "", lastBalancedLocal: Date = Date(), sortIndex: Int64 = Int64.max, createdOnLocal: Date = Date(), transactions: [AccountTransaction]? = []) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.lastBalancedLocal = lastBalancedLocal
        self.sortIndex = sortIndex
        self.createdOnLocal = createdOnLocal
    }

    init(id: UUID = UUID(), name: String, startingBalance: Decimal = 0, currentBalance: Decimal, outstandingBalance: Decimal = 0, outstandingItemCount: Int64 = 0, notes: String = "", lastBalancedUTC: String, sortIndex: Int64 = Int64.max, createdOnUTC: String, transactions: [AccountTransaction]? = []) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self._lastBalancedUTC = lastBalancedUTC
        self.sortIndex = sortIndex
        self._createdOnUTC = createdOnUTC
        debugPrint(self)
    }

    public static func createTable(appContainer: LocalAppStateContainer) {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            try db.run(accountSqlTable.create { t in
                t.column(idColumn, primaryKey: true)
                t.column(nameColumn)
                t.column(startingBalanceColumn)
                t.column(currentBalanceColumn)
                t.column(oustandingBalanceColumn)
                t.column(outstandingItemCountColumn)
                t.column(notesColumn)
                t.column(lastBalancedUTCColumn)
                t.column(sortIndexColumn)
                t.column(createdOnUTCColumn)
            })
        } catch {
            debugPrint("Create Table Account Error: \(error)")
        }
    }

    public static func createAccount(appContainer: LocalAppStateContainer, account: Account) {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)
            try db.run(Account.accountSqlTable.insert(
                Account.idColumn <- account.id.uuidString,
                Account.nameColumn <- account.name,
                Account.startingBalanceColumn <- NSDecimalNumber(decimal: account.startingBalance).doubleValue,
                Account.currentBalanceColumn <- NSDecimalNumber(decimal: account.currentBalance).doubleValue,
                Account.oustandingBalanceColumn <- NSDecimalNumber(decimal: account.outstandingBalance).doubleValue,
                Account.outstandingItemCountColumn <- account.outstandingItemCount.datatypeValue,
                Account.notesColumn <- account.notes,
                Account.lastBalancedUTCColumn <- account._lastBalancedUTC,
                Account.sortIndexColumn <- account.sortIndex.datatypeValue,
                Account.createdOnUTCColumn <- account._createdOnUTC
            ))
        } catch {
            debugPrint("Create Account Error: \(error)")
        }
    }

    public static func getAllAccounts(appContainer: LocalAppStateContainer) -> [Account] {
        var returnList: [Account] = []
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            let query = Account.accountSqlTable.order(Account.sortIndexColumn.asc, Account.nameColumn)

            for entry in try db.prepare(query) {
                let acct = convertEntryToAccount(entry: entry)
                if acct == nil {
                    continue
                } else {
                    returnList.append(acct!)
                }
            }
        } catch {
            debugPrint("Error: \(error)")
        }

        return returnList
    }

    public static func convertEntryToAccount(entry: Row) -> Account? {
        do {
            return try Account(
                id: UUID(uuidString: entry.get(Account.idColumn))!,
                name: entry.get(Account.nameColumn),
                startingBalance: entry.get(Account.startingBalanceColumn).toDecimal(),
                currentBalance: entry.get(Account.currentBalanceColumn).toDecimal(),
                outstandingBalance: entry.get(Account.oustandingBalanceColumn).toDecimal(),
                outstandingItemCount: entry.get(Account.outstandingItemCountColumn),
                notes: entry.get(Account.notesColumn),
                lastBalancedUTC: entry.get(Account.lastBalancedUTCColumn),
                sortIndex: entry.get(Account.outstandingItemCountColumn),
                createdOnUTC: entry.get(Account.createdOnUTCColumn),
                transactions: nil
            )
        } catch {
            debugPrint("Error: \(error)")
            return nil
        }
    }

    public func getTransactionCountForAccount(appContainer: LocalAppStateContainer) -> Int {
        do {
            let db = try Connection(appContainer.loadedUserDbPath!)

            return try db.scalar(Account.accountSqlTable.filter(Account.idColumn == id.uuidString).count)

        } catch {
            debugPrint("Error: \(error)")
        }

        return 0
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
