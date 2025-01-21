//
//  Item.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
