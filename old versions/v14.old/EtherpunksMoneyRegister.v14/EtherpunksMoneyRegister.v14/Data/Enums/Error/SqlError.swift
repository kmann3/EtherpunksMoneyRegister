//
//  SqlError.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/15/24.
//

import Foundation

enum SqlError: Error {
    case databaseNotFound
    case openDatabaseError
}
