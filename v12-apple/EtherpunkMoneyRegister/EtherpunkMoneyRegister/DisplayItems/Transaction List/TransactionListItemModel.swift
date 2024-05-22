//
//  TransactionItemList.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftUI

class TransactionListItem {
    var transaction: AccountTransaction
    
    var backgroundColor: Color
    
    init(transaction: AccountTransaction) {
        self.transaction = transaction
        
        if(transaction.pending == nil && transaction.cleared == nil) {
            backgroundColor = Color(.sRGB, red: 255/255, green: 25/255, blue: 25/255, opacity: 0.5)
        } else if (transaction.pending != nil && transaction.cleared == nil) {
            backgroundColor = Color(.sRGB, red: 255/255, green: 150/255, blue: 25/255, opacity: 0.5)
        } else {
            backgroundColor = Color.clear
        }
    }
}
