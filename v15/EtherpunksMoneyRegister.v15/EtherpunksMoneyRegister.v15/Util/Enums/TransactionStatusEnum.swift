//
//  transactionStatusEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 6/7/24.
//

import Foundation

enum TransactionStatus: Codable, CustomStringConvertible {
    case balanced
    case cleared
    case empty
    case pending
    case recurring
    case reserved

    var description: String {
        switch self {
        case .balanced: return "Balanced"
        case .cleared: return "Cleared"
        case .empty: return "Empty"
        case .pending: return "Pending"
        case .recurring: return "Recurring"
        case .reserved: return "Reserved"
        }
    }
}
