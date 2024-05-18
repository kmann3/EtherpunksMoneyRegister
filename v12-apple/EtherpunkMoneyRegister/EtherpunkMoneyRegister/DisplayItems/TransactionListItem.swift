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
            backgroundColor = Color.red
        } else if (transaction.pending != nil && transaction.cleared == nil) {
            backgroundColor = Color.orange
        } else {
            backgroundColor = Color.clear
        }
    }
}
