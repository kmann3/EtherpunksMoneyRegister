//
//  Item.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 10/14/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id: UUID = UUID.init()
    var timestamp: Date = Date.init()
    var createdOn: Date = Date.init()

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
