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
        RecentFileEntry.createTable(appDbPath: path)
        // More tables may come
    }
}
