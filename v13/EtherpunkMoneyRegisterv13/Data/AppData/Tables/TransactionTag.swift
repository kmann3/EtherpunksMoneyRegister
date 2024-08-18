//
//  Tag.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SQLite3

final class TransactionTag {
    var name: String = ""
    var transactions: [AccountTransaction]? = nil
    var createdOn: Date = Date()

    init(
        name: String = "",
        transactions: [AccountTransaction]? = nil,
        createdOn: Date = Date()
    ) {
        self.name = name
        self.transactions = transactions
        self.createdOn = createdOn
    }

    public static func createTable(db: OpaquePointer?) {
        let createTableSqlString = """
        CREATE TABLE "TransactionTag" (
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
                debugPrint("TransactionTag table could not be created. Error: \(response)")
                return
            }
        } else {
            debugPrint("CREATE TABLE TransactionTag statement could not be prepared.")
            return
        }
        sqlite3_finalize(createTableStatement)

        // Now we make the link table

        let createLinkTableSqlString = """
        CREATE TABLE "Link_Transaction_TransactionTag" (
            "TransactionId" TEXT,
            "TransactionTagId" TEXT,
            "CreatedOn" TEXT
        );
        """

        var createLinkTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createLinkTableSqlString, -1, &createLinkTableStatement, nil) == SQLITE_OK {
            let response = sqlite3_step(createLinkTableStatement)
            if response != SQLITE_DONE {
                debugPrint("Link_Transaction_TransactionTag table could not be created. Error: \(response)")
                return
            }
        } else {
            debugPrint("CREATE TABLE Link_Transaction_TransactionTag statement could not be prepared.")
            return
        }
        sqlite3_finalize(createLinkTableStatement)
    }
}
