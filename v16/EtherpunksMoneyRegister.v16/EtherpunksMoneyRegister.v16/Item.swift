//
//  Item.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/11/26.
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
