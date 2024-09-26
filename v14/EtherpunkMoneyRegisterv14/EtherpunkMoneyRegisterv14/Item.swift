//
//  Item.swift
//  EtherpunkMoneyRegisterv14
//
//  Created by Kennith Mann on 9/26/24.
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
