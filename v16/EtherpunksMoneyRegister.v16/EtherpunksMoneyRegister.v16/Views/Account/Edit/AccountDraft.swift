//
//  AccountDraft.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 3/8/26.
//

import Foundation
struct AccountDraft {
    var name: String
    public var startingBalance: Decimal
    public var notes: String
    public var lastBalancedUTC: Date?

    init(account: Account) {
        name = account.name
        startingBalance = account.startingBalance
        notes = account.notes
        lastBalancedUTC = account.lastBalancedUTC
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
