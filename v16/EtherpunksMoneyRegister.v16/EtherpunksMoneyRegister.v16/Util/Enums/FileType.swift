//
//  FileType.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 7/3/24.
//

import Foundation

enum FileType: String, Hashable, Codable, CustomStringConvertible  {
    case confirmation
    case contract
    case documentation
    case receipt
    case statement
    var description: String {
        switch self {
        case .confirmation: return "Confirmation"
        case .contract: return "Contract"
        case .documentation: return "Documentation"
        case .receipt: return "Receipt"
        case .statement: return "Statement"
        }
    }
}
