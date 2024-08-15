//
//  RecentFileEntries.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/15/24.
//

import Foundation
import SQLite3

final class RecentFileEntries {
    var id: UUID = UUID()
    var path: String = ""
    var createdOn: Date = Date()

    init(path: String) {
        self.path = path
    }

    public static func createTable(db: OpaquePointer?) {
        let createTableSqlString = """
        CREATE TABLE IF NOT EXISTS RecentFileEntries(
        Path TEXT,
        CreatedOn TEXT);
        """

        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableSqlString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) != SQLITE_DONE {
                print("RecentFileEntries table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    public static func getFileEntries(path: String?) throws -> [RecentFileEntries] {
        if(path == nil) {
            throw SqlError.databaseNotFound
        }

        if let db = SqliteActions.openDatabase(at: path!) {
            defer {
                SqliteActions.closeDatabase(db: db)
            }

            print("SELECT query here")
            //createTables(db: db)
            //insertVersionData(db: db)

            return []
        } else {
            throw SqlError.openDatabaseError
        }
    }

    public static func insertFilePath(db: OpaquePointer?, path: String) {
        let insertPathSqlString = """
        INSERT INTO RecentFileEntries(PATH) VALUES (?);
        """

        var insertPathStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertPathSqlString, -1, &insertPathStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(db, 2, path, -1, nil)
            if sqlite3_step(insertPathStatement) != SQLITE_DONE {
                print("Could not insert path")
            }
        }
        sqlite3_finalize(insertPathStatement)
    }
}
