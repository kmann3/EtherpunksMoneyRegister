//
//  TransactionItemList.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftUI

class TransactionListItem {
    var name: String
    var amount: Decimal
    var pending: Date?
    var cleared: Date?
    
    var backgroundColor: Color
    
    init(name: String, amount: Decimal, pending: Date? = nil, cleared: Date? = nil) {
        self.name = name
        self.amount = amount
        self.pending = pending
        self.cleared = cleared
        
        if(pending == nil && cleared == nil) {
            backgroundColor = Color.red
        } else if (pending != nil && cleared == nil) {
            backgroundColor = Color.orange
        } else {
            backgroundColor = Color.clear
        }
    }
}
