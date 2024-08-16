//
//  AppWideState.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 8/3/24.
//

import Foundation
import SQLite3

class LocalAppStateContainer: ObservableObject {
    var loadedSqliteDbPath: String? = nil
    var defaultAccount: Account? = nil
    var appDbPath: String? = nil

    public func loadAppData() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("emr_appdata.sqlite3.emr") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                // Then we open it and see if we have a default entry or a recent entry
                appDbPath = filePath
                print("FILE AVAILABLE at: \(filePath); Let's query it.")
                do {
                    let entryList: [RecentFileEntries] = try RecentFileEntries.getFileEntries(path: filePath)
                    print("Got data \(entryList.count)")
                } catch {
                    print("Failed: \(error.localizedDescription)")
                }

            } else {
                // Then we create it, and keep the path as nil so we know there isn't one made - probably a first time install
                print("FILE NOT AVAILABLE - Creating new file at: \(filePath)")
                createNewAppDatabase(appDatabasePath: pathComponent.path)
                appDbPath = pathComponent.path
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
    }

    private func createNewAppDatabase(appDatabasePath: String) {
        loadedSqliteDbPath = appDatabasePath
        if let db = SqliteActions.openDatabase(at: appDatabasePath) {
            defer {
                SqliteActions.closeDatabase(db: db)
            }
            createTables(db: db, path: appDatabasePath)
        }
    }
    
    private func createTables(db: OpaquePointer?, path: String) {
        RecentFileEntries.createTable(db: db)
    }
}
