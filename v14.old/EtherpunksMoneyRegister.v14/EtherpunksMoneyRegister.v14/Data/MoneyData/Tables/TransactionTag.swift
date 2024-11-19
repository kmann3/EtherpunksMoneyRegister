//
//  Tag.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation

final class TransactionTag : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var accountTransactions: [AccountTransaction]? = nil
    public var createdOnUTC: Date  = Date()

    public var debugDescription: String {
            return """
            TransactionTag:
            - id: \(id)
            - name: \(name)
            - createdOnUTC: \(createdOnUTC)
            """
    }

    init(
        id: UUID = UUID(),
        name: String,
        accountTransactions: [AccountTransaction]? = nil
    ) {
        self.id = id
        self.name = name
        self.accountTransactions = accountTransactions
    }
}
