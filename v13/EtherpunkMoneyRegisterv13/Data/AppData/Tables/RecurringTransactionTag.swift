//
//  RecurringTransactionTag.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/12/24.
//

import Foundation
import SQLite3

final class RecurringTransactionTag {
    var name: String = ""
    var recurringTransactions: [RecurringTransaction]? = nil
    var createdOn: Date = Date()

    init(
        name: String = "",
        recurringTransactions: [RecurringTransaction]? = nil,
        createdOn: Date = Date()
    ) {
        self.name = name
        self.recurringTransactions = recurringTransactions
        self.createdOn = createdOn
    }

    public static func createTable(db: OpaquePointer?) {
        let createTableSqlString = """
        CREATE TABLE "RecurringTransactionTag" (
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
                print("RecurringTransactionTag table could not be created. Error: \(response)")
                return
            }
        } else {
            print("CREATE TABLE RecurringTransactionTag statement could not be prepared.")
            return
        }
        sqlite3_finalize(createTableStatement)

        // Now we make the link table

        let createLinkTableSqlString = """
        CREATE TABLE "Link_RecurringTransaction_RecurringTransactionTag" (
            "RecurringTransactionId" TEXT,
            "RecurringTransactionTagId" TEXT,
            "CreatedOn" TEXT
        );
        """

        var createLinkTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createLinkTableSqlString, -1, &createLinkTableStatement, nil) == SQLITE_OK {
            let response = sqlite3_step(createLinkTableStatement)
            if response != SQLITE_DONE {
                print("Link_RecurringTransaction_RecurringTransactionTag table could not be created. Error: \(response)")
                return
            }
        } else {
            print("CREATE TABLE Link_RecurringTransaction_RecurringTransactionTag statement could not be prepared.")
            return
        }
        sqlite3_finalize(createLinkTableStatement)
    }
}
