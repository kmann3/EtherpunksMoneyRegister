//
//  Item.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 10/1/24.
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
