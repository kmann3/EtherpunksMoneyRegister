//
//  Account.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SQLite3

final class Account {
    var id: UUID = UUID()
    var name: String = ""
    var startingBalance: Decimal = 0
    var currentBalance: Decimal = 0
    var outstandingBalance: Decimal = 0
    var outstandingItemCount: Int = 0
    var notes: String = ""
    var lastBalanced: Date = Date()
    var sortIndex: Int = 255
    var createdOn: Date = Date()

    var transactionCount: Int = 0

    var transactions: [AccountTransaction]?

    init(id: UUID = UUID(), name: String, startingBalance: Decimal, currentBalance: Decimal, outstandingBalance: Decimal, outstandingItemCount: Int, notes: String, lastBalanced: Date = Date(), sortIndex: Int = 255, createdOn: Date = Date(), transactions: [AccountTransaction]? = []) {
        self.id = id
        self.name = name
        self.startingBalance = startingBalance
        self.currentBalance = currentBalance
        self.outstandingBalance = outstandingBalance
        self.outstandingItemCount = outstandingItemCount
        self.notes = notes
        self.lastBalanced = lastBalanced
        self.sortIndex = sortIndex
        self.createdOn = createdOn
        self.transactions = transactions

        if(transactions == nil || transactions!.isEmpty) {
            self.transactionCount = 0
        } else {
            self.transactionCount = transactions!.count
        }
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
        self.createdOn = Date()
        self.transactions = []
        self.transactionCount = 0
    }
    public static func createTable(db: OpaquePointer?) {
        let createTableSqlString = """
        CREATE TABLE "Account" (
            "Id" TEXT,
            "Name" TEXT,
            "StartingBalance" REAL,
            "CurrentBalance" REAL,
            "OutstandingBalance" REAL,
            "OutstandingItemCount" INTEGER,
            "Notes" TEXT,
            "LastBalanced" TEXT,
            "SortIndex" INTEGER,
            "CreatedOn" TEXT,
            PRIMARY KEY("Id")
        );
        """

        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableSqlString, -1, &createTableStatement, nil) == SQLITE_OK {
            let response = sqlite3_step(createTableStatement)
            if response != SQLITE_DONE {
                print("Account table could not be created. Error: \(response)")
                return
            }
        } else {
            print("CREATE TABLE Account statement could not be prepared.")
            return
        }
        sqlite3_finalize(createTableStatement)
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
//            print("Error saving account: \(error)")
//        }
//    }
//
//    func rebalance(amount: Decimal, dateToBegin: Date? = nil, modelContext: ModelContext) {
//
//        if(self.transactionCount == 0) {
//            print("Empty")
//            return
//        }
//
//        debugPrint("Begin predicate")
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
//            debugPrint("Begin loop")
//            for transaction in newTransactions {
//                debugPrint("Transaction: \(transaction.name)")
//                transaction.balance += amount
//            }
//            try modelContext.save()
//        } catch {
//            DispatchQueue.main.async {
//                print("Error fetching transactions: \(error.localizedDescription)")
//            }
//        }
//
//    }
}
