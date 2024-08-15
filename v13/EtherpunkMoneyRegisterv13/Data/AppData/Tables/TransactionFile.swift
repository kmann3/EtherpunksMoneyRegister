//
//  AccountTransactionFile.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/30/24.
//

import Foundation
import SQLite3

final class TransactionFile {
    var id: UUID = UUID()
    var name: String = ""
    var filename: String = ""
    var notes: String = ""
    var createdOn: Date = Date()
    var url: URL? = nil
    var data: Data? = nil
    var isTaxRelated: Bool = false
    var fileType: FileType? = nil
    var transaction: AccountTransaction?
    var transactionId: UUID? = nil

    init(id: UUID = UUID(), name: String = "", filename: String = "", notes: String = "", createdOn: Date = Date(), url: URL? = nil, data: Data? = nil, fileType: FileType? = nil ,isTaxRelated: Bool = false, transaction: AccountTransaction? = nil, transactionId: UUID? = nil) {
        self.id = id
        self.name = name
        self.filename = filename
        self.notes = notes
        self.createdOn = createdOn
        self.url = url
        self.data = data
        self.transaction = transaction
        self.isTaxRelated = isTaxRelated
        self.fileType = fileType
        if(transactionId == nil) {
            self.transactionId = transaction!.id
        } else {
            self.transactionId = transactionId
        }
    }

    // other types of files?
    // Account - contracts, opening papers, statements
    // Recurring Transactions - contracts

    // Files might also have different tags such as: receipt, documentation, confirmation

    public static func createTable(db: OpaquePointer?) {
        let createTableSqlString = """
        CREATE TABLE "TransactionFile" (
            "Id" TEXT,
            "Name" TEXT,
            "Filename" TEXT,
            "Notes" TEXT,
            "Data" BLOB,
            "TransactionId" TEXT,
            "IsTaxRelated" INTEGER,
            "FileType" TEXT,
            "CreatedOn" TEXT,
            PRIMARY KEY("Id")
        );
        """

        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableSqlString, -1, &createTableStatement, nil) == SQLITE_OK {
            let response = sqlite3_step(createTableStatement)
            if response != SQLITE_DONE {
                print("TransactionFile table could not be created. Error: \(response)")
                return
            }
        } else {
            print("CREATE TABLE TransactionFile statement could not be prepared.")
            return
        }
        sqlite3_finalize(createTableStatement)
    }
}
