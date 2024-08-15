//
//  DbController.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/9/24.
//

import Foundation
import SQLite3

class DbController {

    public static func createDatabase(path: String) {
        let db = SqliteActions.openDatabase(at: path)
        defer {
            SqliteActions.closeDatabase(db: db)
        }

        Account.createTable(db: db)
        AccountTransaction.createTable(db: db)
        RecurringTransaction.createTable(db: db)
        RecurringTransactionGroup.createTable(db: db)
        RecurringTransactionTag.createTable(db: db)
        TransactionFile.createTable(db: db)
        TransactionTag.createTable(db: db)
    }
}
