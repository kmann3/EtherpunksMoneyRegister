//
//  TransactionTypeEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation

enum TransactionType: Int, Codable, CustomStringConvertible {
    case credit = 0
    case debit = 1

    var description: String {
        switch self {
        case .credit: return "Credit"
        case .debit: return "Debit"
        }
    }
}
