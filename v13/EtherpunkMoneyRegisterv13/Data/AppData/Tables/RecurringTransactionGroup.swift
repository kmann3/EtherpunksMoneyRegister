//
//  RecurringTransactionGroup.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
//import SwiftData
import SQLite3

final class RecurringTransactionGroup {
    var id: UUID = UUID()
    var name: String = ""
    var createdOn: Date = Date()

    var recurringTransactions: [RecurringTransaction]?

    init(id: UUID = UUID(), name: String, createdOn: Date = Date(), recurringTransactions: [RecurringTransaction]? = []) {
        self.id = id
        self.name = name
        self.createdOn = createdOn
        self.recurringTransactions = recurringTransactions
    }

    public static func createTable(db: OpaquePointer?) {
        let createTableSqlString = """
        CREATE TABLE "RecurringTransactionGroup" (
            "Id" TEXT,
            "Name" TEXT,
            "CreatedOn" TEXT,
            PRIMARY KEY("Id")
        );
        """

        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableSqlString, -1, &createTableStatement, nil) == SQLITE_OK {
            let response = sqlite3_step(createTableStatement)
            if response != SQLITE_DONE {
                print("RecurringTransactionGroup table could not be created. Error: \(response)")
                return
            }
        } else {
            print("CREATE TABLE RecurringTransactionGroup statement could not be prepared.")
            return
        }
        sqlite3_finalize(createTableStatement)
    }
}
