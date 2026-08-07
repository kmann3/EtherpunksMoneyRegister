//
//  Sync.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 8/7/26.
//


import Foundation
import SwiftData
import SwiftUI
import UUIDV7

@Model
final class Sync: Identifiable, Hashable {
    public var id: UUIDV7 = UUIDV7()
    public var tableName: TableName {
        get { TableName(rawValue: tableNameRaw) ?? .accountTransaction }
        set { tableNameRaw = newValue.rawValue }
    }
    private var tableNameRaw: TableName.RawValue = TableName.accountTransaction.rawValue
    
    public var itemId: UUIDV7 = UUIDV7.init(uuidString: "00000000-0000-0000-0000-00000000000").unsafelyUnwrapped
    
    public var createdOnUTC: Date = Date()


 
    init(
        id: UUIDV7 = UUIDV7(),
        itemId: UUIDV7,
        tableName: TableName
    ) {
        self.id = id
        self.itemId = itemId
        self.tableName = tableName
    }
}

@MainActor
extension Sync: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            RecurringGroup:
            - id: \(id)
            - itemId: \(itemId)
            - tableName: \(tableName)
            - createdOnUTC: \(createdOnUTC.toDebugDate())
            """
    }
}
