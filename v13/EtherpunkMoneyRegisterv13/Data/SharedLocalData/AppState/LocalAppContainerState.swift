//
//  AppWideState.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 8/3/24.
//

import Foundation
import SQLite3

class LocalAppStateContainer: ObservableObject {
    /// This database holds the users financial data
    public var loadedUserDbPath: String? = nil
    public var defaultAccount: Account? = nil

    /// This database is for app settings.
    public var appDbPath: String? = nil
    public var recentFileEntries: [RecentFileEntry] = []

    public var setRecentListToZero: Bool = false
    public var makeAppDbNew: Bool = false

    public func loadAppData() {

        let fileManager = FileManager.default
        let filePath = getAppDbPath()
        debugPrint(filePath)
        do {
            if makeAppDbNew {
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            print("Error deleting AppDb: \(error)")
        }


        if fileManager.fileExists(atPath: filePath) {
            // Then we open it and see if we have a default entry or a recent entry
            appDbPath = filePath
            debugPrint("FILE AVAILABLE at: \(filePath); Let's query it.")

            if !setRecentListToZero && recentFileEntries.count == 0 {
                recentFileEntries = RecentFileEntry.getFileEntries(appDbPath: filePath)
                // Now we go through the file entries and get the size of the database
            }
            debugPrint("Got data. Item count: \(recentFileEntries.count)")
        } else {
            // Then we create it, and keep the path as nil so we know there isn't one made - probably a first time install
            debugPrint("FILE NOT AVAILABLE - Creating new file at: \(filePath)")
            createNewAppDatabase(appContainer: self)
            appDbPath = filePath
        }
    }

    public func getAppDbPath() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("emr_appdata.sqlite3.emr") {
            return pathComponent.path
        } else {
            debugPrint("Error finding path")
            return ""
        }
    }

    private func createNewAppDatabase(appContainer: LocalAppStateContainer) {
        createTables(appContainer: appContainer)
    }
    
    private func createTables(appContainer: LocalAppStateContainer) {
        RecentFileEntry.createTable(appContainer: appContainer)
    }
}
