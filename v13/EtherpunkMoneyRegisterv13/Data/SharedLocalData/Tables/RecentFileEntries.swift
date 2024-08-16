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

    init(id: UUID, path: String, createdOn: Date) {
        self.id = id
        self.path = path
        self.createdOn = createdOn
    }

    init(path: String) {
        self.path = path
    }

    init() {}

    public static func createTable(db: OpaquePointer?) {
        let createTableSqlString = """
        CREATE TABLE IF NOT EXISTS RecentFileEntries(
        "Id" TEXT,
        "Path" TEXT,
        "CreatedOn" TEXT);
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

            var returnData: [RecentFileEntries] = []

            let querySqlString = """
            SELECT Id, Path, CreatedOn FROM RecentFileEntries ORDER BY CreatedOn DESC;
            """

            var queryStatement: OpaquePointer?
            if sqlite3_prepare_v2(db, querySqlString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    guard let queryResultCol0 = sqlite3_column_text(queryStatement, 0) else {
                        print("ERROR: Query result (id) is nil")
                        return returnData
                    }
                    //let col0_id = UUID(uuidString: String(cString: queryResultCol0))
                    let col0_id = String(cString: queryResultCol0)

                    guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                        print("ERROR: Query result (path) is nil")
                        return returnData
                    }

                    let col1_path = String(cString: queryResultCol1)

                    guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
                        print("ERROR: Query result (path) is nil")
                        return returnData
                    }

                    let col2_createdOn_string = String(cString: queryResultCol2)
                    print("\(col0_id) | \(col1_path) | \(col2_createdOn_string)")

                    var entry: RecentFileEntries = RecentFileEntries()
                    entry.id = UUID(uuidString: col0_id)!
                    entry.path = col1_path

                    let formatter = DateFormatter()
                    formatter.timeZone = TimeZone(abbreviation: "UTC")
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    entry.createdOn = formatter.date(from: col2_createdOn_string)!

                    returnData.append(entry)

                }
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Query is not prepared: \(errorMessage)")
            }
            sqlite3_finalize(queryStatement)

            return returnData
        } else {
            throw SqlError.openDatabaseError
        }
    }

    public static func insertFilePath(db: OpaquePointer?, path: String) {
        let insertPathSqlString = """
        INSERT INTO RecentFileEntries(Id, Path, CreatedOn) VALUES (?, ?, ?);
        """

        let id: String = UUID().uuidString

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'" // Example format: 2024-08-15T14:30:00Z
        let createdOn: String = formatter.string(from: Date())

        print("ID: \(id) | Path: \(path) | CreatedOn: \(createdOn)")

        var insertPathStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertPathSqlString, -1, &insertPathStatement, nil) == SQLITE_OK {

            if let idCString = id.cString(using: .utf8) {
                sqlite3_bind_text(insertPathStatement, 1, idCString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            }

            if let pathCString = path.cString(using: .utf8) {
                sqlite3_bind_text(insertPathStatement, 2, pathCString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            }

            if let createdOnCString = createdOn.cString(using: .utf8) {
                sqlite3_bind_text(insertPathStatement, 3, createdOnCString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
            }

            if sqlite3_step(insertPathStatement) != SQLITE_DONE {
                print("Could not insert path")
            }
        }
        sqlite3_finalize(insertPathStatement)
    }

    public static func insertFilePath(appContainer: LocalAppStateContainer) throws {
        if(appContainer.appDbPath == nil || appContainer.loadedSqliteDbPath == nil) {
            print("path error: app:\(appContainer.appDbPath ?? "") | db:\(appContainer.loadedSqliteDbPath ?? "") ")
            throw SqlError.databaseNotFound
        }

        if let db = SqliteActions.openDatabase(at: appContainer.appDbPath!) {
            defer {
                SqliteActions.closeDatabase(db: db)
            }

            insertFilePath(db: db, path: appContainer.loadedSqliteDbPath!)
        } else {
            print("error with insert sql")
            throw SqlError.openDatabaseError
        }
    }
}
