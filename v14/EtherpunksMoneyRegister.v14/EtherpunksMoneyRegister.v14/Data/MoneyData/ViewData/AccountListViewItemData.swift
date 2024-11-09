//
//  AccountListViewItemData.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/18/24.
//

import Foundation

class AccountListViewItemData: ObservableObject, CustomDebugStringConvertible, Identifiable {
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
}
