//
//  AppSettings.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 7/19/24.
//

import Foundation
import SQLite3

class AppSettingsTwo: ObservableObject {
    // @Published var loadedDatabasePointer: OpaquePointer? = nil
    @Published var loadedDatabasePath: URL? = nil

    public func LoadAppData() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("emr_appdata.sqlite3") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                // Then we open it and see if we have a default entry or a recent entry
                debugPrint("FILE AVAILABLE at: \(filePath)")
            } else {
                // Then we create it, and keep the path as nil so we know there isn't one made - probably a first time install
                debugPrint("FILE NOT AVAILABLE - Creating new file at: \(filePath)")
                createNewAppDatabase(appDatabasePath: pathComponent)
            }
        } else {
            debugPrint("FILE PATH NOT AVAILABLE")
        }
    }

    private func createNewAppDatabase(appDatabasePath: URL) {
        loadedDatabasePath = appDatabasePath
        if let db = openDatabase(at: appDatabasePath.path) {
            createTables(db: db)
            closeDatabase(db: db)
        }
    }

    private func openDatabase(at path: String) -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) != SQLITE_OK {
            debugPrint("Error opening database")
            return nil
        }
        debugPrint("Successfully opened connection to database at \(path)")
        return db
    }

    private func createTables(db: OpaquePointer?) {
        let createEntryTableSqlString = """
        CREATE TABLE IF NOT EXISTS RecentEntries(
        Path TEXT,
        CreatedOn TEXT);
        """

        var createEntryTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createEntryTableSqlString, -1, &createEntryTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createEntryTableStatement) == SQLITE_DONE {
                debugPrint("Entry table created.")
            } else {
                debugPrint("Entry table could not be created.")
            }
        } else {
            debugPrint("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createEntryTableStatement)

        let createVersionTableSqlString = """
        CREATE TABLE IF NOT EXISTS Version(
        VersionNumber INTEGER);
        """

        var createVersionTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createVersionTableSqlString, -1, &createVersionTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createVersionTableStatement) == SQLITE_DONE {
                debugPrint("Version table created.")
            } else {
                debugPrint("Version table could not be created.")
            }
        } else {
            debugPrint("CREATE Version TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createVersionTableStatement)

        let version: Int32 = 1

        let setCurrentVersionSqlString = "INSERT INTO Version (VersionNumber) VALUES (?);"
        var setCurrentVersionStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, setCurrentVersionSqlString, -1, &setCurrentVersionStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(setCurrentVersionStatement, 1, version)
            if sqlite3_step(setCurrentVersionStatement) == SQLITE_DONE {
                debugPrint("\nSuccessfully set version.")
            } else {
                debugPrint("\nCould not set version / insert row")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
                debugPrint("\nSet Version statement is not prepared! \(errorMessage)")
            debugPrint("\nINSERT statement for set version is not prepared.")
        }

        sqlite3_finalize(setCurrentVersionStatement)

//        // we now, of course, add this new database to the entry list
//        let path: String = loadedDatabasePath!.path()
//        var createdOn: String {
//            let date = Date()
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd:HH.mm.ss"
//            return formatter.string(from: date)
//        }
//
//        let addNewEntryString = "INSERT INTO RecentEntries (Path, CreatedOn) VALUES (?, ?);"
//        debugPrint(addNewEntryString)
//        var addnewEntryStatement: OpaquePointer?
//        if sqlite3_prepare_v2(db, addNewEntryString, -1, &addnewEntryStatement, nil) ==
//            SQLITE_OK
//        {
//            let path: NSString = path as NSString
//            var createdOn: NSString {
//                let date = Date()
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd:HH.mm.ss"
//                return formatter.string(from: date) as NSString
//            }
//            sqlite3_bind_text(addnewEntryStatement, 1, path.utf8String, -1, nil)
//            sqlite3_bind_text(addnewEntryStatement, 2, createdOn.utf8String, -1, nil)
//
//            if sqlite3_step(addnewEntryStatement) == SQLITE_DONE {
//                debugPrint("\nSuccessfully inserted row.")
//            } else {
//                debugPrint("\nCould not insert row.")
//            }
//        } else {
//            let errorMessage = String(cString: sqlite3_errmsg(db))
//                debugPrint("\nQuery is not prepared! \(errorMessage)")
//            debugPrint("\nINSERT statement is not prepared.")
//        }
//
//        sqlite3_finalize(addnewEntryStatement)
    }

    private func closeDatabase(db: OpaquePointer?) {
        if sqlite3_close(db) != SQLITE_OK {
            debugPrint("Error closing database")
        } else {
            debugPrint("Database closed successfully")
        }
    }
}
