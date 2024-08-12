//
//  DbController.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/9/24.
//

import Foundation
import SQLite3

class DbController {

    public static func createDatabase() {
        
    }

    public static func closeDatabase(db: OpaquePointer?) {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        } else {
            print("Database closed successfully")
        }
    }

    public static func openDatabase(at path: String) -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        }
        print("Successfully opened connection to database at \(path)")
        return db
    }
}

enum SqlError: Error {
    case databaseNotFound
    case openDatabaseError
}
