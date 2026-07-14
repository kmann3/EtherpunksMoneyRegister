//
//  TransactionTypeEnum.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/14/26.
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
