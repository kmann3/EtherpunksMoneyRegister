//
//  AppWideState.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 8/3/24.
//

import Foundation
import SQLite3

class AppStateContainer: ObservableObject {
    var tabViewState = TabViewState()
    var loadedSqliteDbPath: URL? = nil
    var defaultAccount: Account? = nil

    public func loadAppData() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("emr_appdata.sqlite3.emr") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                // Then we open it and see if we have a default entry or a recent entry
                print("FILE AVAILABLE at: \(filePath)")
            } else {
                // Then we create it, and keep the path as nil so we know there isn't one made - probably a first time install
                print("FILE NOT AVAILABLE - Creating new file at: \(filePath)")
                createNewAppDatabase(appDatabasePath: pathComponent)
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }

    public func createNewUserDatabase(location: String) {

    }

    public func openUserDatabase(location: String) {

    }

    private func createNewAppDatabase(appDatabasePath: URL) {
        loadedSqliteDbPath = appDatabasePath
        if let db = openDatabase(at: appDatabasePath.path) {
            defer {
                closeDatabase(db: db)
            }
            createTables(db: db)
            insertVersionData(db: db)
        }
    }

    private func openDatabase(at path: String) -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        }
        print("Successfully opened connection to database at \(path)")
        return db
    }

    private func createTables(db: OpaquePointer?) {
        createFileEntryTabe(db: db)
        createVersionTable(db: db)
    }

    private func createFileEntryTabe(db: OpaquePointer?) {
        let createEntryTableSqlString = """
        CREATE TABLE IF NOT EXISTS RecentFileEntries(
        Path TEXT,
        CreatedOn TEXT);
        """

        var createEntryTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createEntryTableSqlString, -1, &createEntryTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createEntryTableStatement) == SQLITE_DONE {
                print("RecentFileEntries table created.")
            } else {
                print("RecentFileEntries table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createEntryTableStatement)
    }

    private func createVersionTable(db: OpaquePointer?) {
        let createVersionTableSqlString = """
        CREATE TABLE IF NOT EXISTS Version(
        VersionNumber INTEGER);
        """

        var createVersionTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createVersionTableSqlString, -1, &createVersionTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createVersionTableStatement) == SQLITE_DONE {
                print("Version table created.")
            } else {
                print("Version table could not be created.")
            }
        } else {
            print("CREATE Version TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createVersionTableStatement)
    }

    private func insertVersionData(db: OpaquePointer?) {
        let version: Int32 = 1

        let setCurrentVersionSqlString = "INSERT INTO Version (VersionNumber) VALUES (?);"
        var setCurrentVersionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, setCurrentVersionSqlString, -1, &setCurrentVersionStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(setCurrentVersionStatement, 1, version)
            if sqlite3_step(setCurrentVersionStatement) == SQLITE_DONE {
                print("\nSuccessfully set version.")
            } else {
                print("\nCould not set version / insert row")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nSet Version statement is not prepared! \(errorMessage)")
            print("\nINSERT statement for set version is not prepared.")
        }

        sqlite3_finalize(setCurrentVersionStatement)
    }

    private func closeDatabase(db: OpaquePointer?) {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        } else {
            print("Database closed successfully")
        }
    }
}

class TabViewState: ObservableObject {
    @Published var selectedTab: Tab = .accounts
}
