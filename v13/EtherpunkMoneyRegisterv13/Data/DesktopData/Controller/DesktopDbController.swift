//
//  DesktopDbController.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/15/24.
//

import Foundation
import SQLite3

class DesktopDbController {

    public static func createDatabase(appContainer: LocalAppStateContainer) {
        RecentFileEntry.createTable(appContainer: appContainer)
        // More tables may come
    }
}
