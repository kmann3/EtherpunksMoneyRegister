//
//  AccountListViewItemData.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/18/24.
//

import Foundation
import SQLite

class AccountListViewItemData : ObservableObject, CustomDebugStringConvertible, Identifiable  {

    public var account: Account
    public var transactionCount: Int
    var debugDescription: String {
            return """
            AccountListViewItemData:
            - account: \n\(account)
            - transactionCount: \(transactionCount)
            """
    }

    init(account: Account, transactionCount: Int = 0) {
        self.account = account
        self.transactionCount = transactionCount
    }

    public static func getAllAccountData(appContainer: LocalAppStateContainer) -> [AccountListViewItemData] {
        var returnData: [AccountListViewItemData] = []

        let accountList = Account.getAllAccounts(appContainer: appContainer)

        for account in accountList {
            // now we get the transaction count and make + add the view item data to the array
            debugPrint("Account name: \(account.name)")
            var item: AccountListViewItemData = AccountListViewItemData(account: account, transactionCount: account.getTransactionCountForAccount(appContainer: appContainer))
            returnData.append(item)
        }

        return returnData
    }
}
