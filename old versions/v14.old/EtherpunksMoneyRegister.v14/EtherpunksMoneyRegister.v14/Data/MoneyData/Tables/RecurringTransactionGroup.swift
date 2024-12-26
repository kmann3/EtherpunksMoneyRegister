//
//  RecurringTransactionGroup.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
final class RecurringTransactionGroup : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var recurringTransactions: [RecurringTransaction]? = nil
    public var createdOnUTC: Date = Date()

    public var debugDescription: String {
            return """
            RecurringTransactionGroup:
            - id: \(id)
            - name: \(name)
            - createdOnUTC: \(createdOnUTC)
            """
    }

   init(
    name: String = "",
    recurringTransactions: [RecurringTransaction]? = nil
   ) {
       self.name = name
       self.recurringTransactions = recurringTransactions
   }

    init(name: String) {
        self.name = name
    }
}
