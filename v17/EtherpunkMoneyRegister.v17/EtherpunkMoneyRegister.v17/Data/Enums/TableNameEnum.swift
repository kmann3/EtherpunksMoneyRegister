//
//  TableNameEnum.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 8/7/26.
//

import Foundation

enum TableName: String, Codable, CustomStringConvertible {
    case account
    case accountTransaction
    case recurringGroup
    case recurringTransaction
    case transactionFile
    case transactionTag

    var description: String {
        switch self {
        case .account: return "account"
        case .accountTransaction: return "accountTransaction"
        case .recurringGroup: return "recurringGroup"
        case .recurringTransaction: return "recurringTransaction"
        case .transactionFile: return "transactionFile"
        case .transactionTag: return "transactionTag"
        }
    }
}
