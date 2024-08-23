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
        Account.createTable(appContainer: appContainer)
        Account.createTable(appContainer: appContainer)
        AccountTransaction.createTable(appContainer: appContainer)
        RecurringTransaction.createTable(appContainer: appContainer)
        RecurringTransactionGroup.createTable(appContainer: appContainer)
        RecurringTransactionTag.createTable(appContainer: appContainer)
        Link_RecurringTransaction_RecurringTransactionTag.createTable(appContainer: appContainer)
        TransactionFile.createTable(appContainer: appContainer)
        TransactionTag.createTable(appContainer: appContainer)
        Link_Transaction_TransactionTag.createTable(appContainer: appContainer)

        RecentFileEntry.insertFilePath(appContainer: appContainer)
    }
}
