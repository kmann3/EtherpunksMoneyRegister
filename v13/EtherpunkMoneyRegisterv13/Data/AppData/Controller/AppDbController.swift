//
//  DbController.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/9/24.
//

import Foundation
import SQLite3

class DbController {

    public static func createDatabaseOld(appContainer: LocalAppStateContainer) {
        let db = SqliteActions.openDatabase(at: appContainer.loadedSqliteDbPath!)
        defer {
            SqliteActions.closeDatabase(db: db)
        }

        //Account.createTable(db: db)
        //AccountTransaction.createTable(db: db)
        //RecurringTransaction.createTable(db: db)
        RecurringTransactionGroup.createTable(db: db)
        RecurringTransactionTag.createTable(db: db)
        TransactionFile.createTable(db: db)
        TransactionTag.createTable(db: db)

        RecentFileEntry.insertFilePath(appContainer: appContainer)
    }

    public static func createDatabase(appContainer: LocalAppStateContainer) {
        Account.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        AccountTransaction.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        RecurringTransaction.createTable(appDbPath: appContainer.loadedSqliteDbPath!)

        RecentFileEntry.insertFilePath(appContainer: appContainer)
    }
}
