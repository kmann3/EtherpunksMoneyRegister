//
//  AccountListViewItemData.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/18/24.
//

import Foundation

class OldAccountListItemViewData: ObservableObject, CustomDebugStringConvertible, Identifiable {
    public var account: Account
    var debugDescription: String {
        return """
        OldAccountListItemViewData:
        - account: \n\(account)
        - transactionCount: \(account.transactionCount)
        """
    }

    init(account: Account) {
        self.account = account
    }
}
