//
//  DbController.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/9/24.
//

import Foundation
import SQLite3

class DbController {
    public static func createDatabase(appContainer: LocalAppStateContainer) {
        Account.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        AccountTransaction.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        RecurringTransaction.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        RecurringTransactionGroup.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        RecurringTransactionTag.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        Link_RecurringTransaction_RecurringTransactionTag.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        TransactionFile.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        TransactionTag.createTable(appDbPath: appContainer.loadedSqliteDbPath!)
        Link_Transaction_TransactionTag.createTable(appDbPath: appContainer.loadedSqliteDbPath!)

        RecentFileEntry.insertFilePath(appContainer: appContainer)
    }
}
