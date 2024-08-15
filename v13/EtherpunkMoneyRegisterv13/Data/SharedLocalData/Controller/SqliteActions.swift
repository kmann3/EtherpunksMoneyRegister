//
//  SqliteActions.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/15/24.
//

import Foundation
import SQLite3

class SqliteActions {
    public static func openDatabase(at path: String) -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        }
        print("Database opened at: \(path)")
        return db
    }

    public static func closeDatabase(db: OpaquePointer?) {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
        print("Database closed")
    }
}
