//
//  Item.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/15/24.
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
