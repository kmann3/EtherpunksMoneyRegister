//
//  FileType.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 7/3/24.
//

import Foundation

enum FileType: Hashable, Codable {
    case confirmation
    case contract
    case documentation
    case receipt
    case statement
}
