//
//  transactionStatusEnum.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 6/7/24.
//

import Foundation

enum TransactionStatus: Codable {
    case cleared
    case empty
    case pending
    case recurring
    case reserved
}
