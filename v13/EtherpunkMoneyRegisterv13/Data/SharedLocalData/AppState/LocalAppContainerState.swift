//
//  AppWideState.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 8/3/24.
//

import Foundation
import SQLite3

class LocalAppStateContainer: ObservableObject {
    public var loadedSqliteDbPath: String? = nil
    public var defaultAccount: Account? = nil
    public var appDbPath: String? = nil
    public var recentFileEntries: [RecentFileEntry] = []

    public func loadAppData() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("emr_appdata.sqlite3.emr") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                // Then we open it and see if we have a default entry or a recent entry
                appDbPath = filePath
                debugPrint("FILE AVAILABLE at: \(filePath); Let's query it.")

                recentFileEntries = RecentFileEntry.getFileEntries(appDbPath: filePath)
                debugPrint("Got data. Item count: \(recentFileEntries.count)")
            } else {
                // Then we create it, and keep the path as nil so we know there isn't one made - probably a first time install
                debugPrint("FILE NOT AVAILABLE - Creating new file at: \(filePath)")
                createNewAppDatabase(appDatabasePath: pathComponent.path)
                appDbPath = pathComponent.path
            }
        } else {
            debugPrint("FILE PATH NOT AVAILABLE")
        }
    }

    private func createNewAppDatabase(appDatabasePath: String) {
        createTables(path: appDatabasePath)
    }
    
    private func createTables(path: String) {
        RecentFileEntry.createTable(appDbPath: path)
    }
}
