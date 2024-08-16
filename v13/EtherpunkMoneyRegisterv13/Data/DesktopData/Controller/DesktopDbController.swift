//
//  DesktopDbController.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/15/24.
//

import Foundation
import SQLite3

class DesktopDbController {
    public static func createDatabase(path: String) {
        let db = SqliteActions.openDatabase(at: path)
        defer {
            SqliteActions.closeDatabase(db: db)
        }

        RecentFileEntries.createTable(db: db)
    }

    public static func insertNewRecentFileEntry(appContainer: LocalAppStateContainer) {
        do {
            try RecentFileEntries.insertFilePath(appContainer: appContainer)
        } catch {
            print(error.localizedDescription)
        }
    }
}
