//
//  Draft.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/20/26.
//

import Foundation
import SwiftUI

struct Draft {
    var name: String
    var account: Account
    var transactionType: TransactionType
    var amount: Decimal
    var isTaxRelated: Bool
    var confirmationNumber: String
    var notes: String
    var fileCount: Int
    var pendingOn: Date?
    var clearedOn: Date?
    var balancedOn: Date?
    var dueDate: Date?
    var tags: [TransactionTag]
    var hasPending: Bool
    var hasCleared: Bool
    var hasDueDate: Bool
    var hasBalanced: Bool
    
    var recurringTransaction: RecurringTransaction? = nil
    
    public var backgroundColor: Color {
        switch self.transactionStatus {
        case .balanced:
            Color(
                .sRGB, red: 0 / 255, green: 150 / 255, blue: 25 / 255,
                opacity: 0.5)
        case .cleared:
            Color.clear
        case .empty:
            Color.clear
        case .recurring:
            // blue
            Color(
                .sRGB, red: 0 / 255, green: 80 / 255, blue: 150 / 255,
                opacity: 0.5)
        case .pending:
            // yellow
            Color(
                .sRGB, red: 255 / 255, green: 150 / 255, blue: 25 / 255,
                opacity: 0.5)
        case .reserved:
            // red
            Color(
                .sRGB, red: 255 / 255, green: 25 / 255, blue: 25 / 255,
                opacity: 0.5)
        }
    }
    
    public var transactionStatus: TransactionStatus {
        if self.pendingOn == nil && self.clearedOn == nil {
            return .reserved
        } else if self.pendingOn != nil && self.clearedOn == nil {
            return .pending
        } else {
            if self.recurringTransaction != nil {
                return .recurring
            } else if self.balancedOn != nil {
                return .balanced
            } else if self.clearedOn != nil {
                return .cleared
            }
            return .empty
        }
    }

    init(tran: AccountTransaction) {
        name = tran.name
        account = tran.account
        transactionType = tran.transactionType
        amount = tran.amount
        isTaxRelated = tran.isTaxRelated
        confirmationNumber = tran.confirmationNumber
        notes = tran.notes
        fileCount = tran.fileCount
        pendingOn = tran.pendingOnUTC // Is this really UTC? How does DT work in Swift?
        clearedOn = tran.clearedOnUTC // Is this really UTC? How does DT work in Swift?
        balancedOn = tran.balancedOnUTC
        dueDate = tran.dueDate
        tags = tran.transactionTags
        hasPending = tran.pendingOnUTC != nil
        hasCleared = tran.clearedOnUTC != nil
        hasDueDate = tran.dueDate != nil
        hasBalanced = tran.balancedOnUTC != nil
        
        recurringTransaction = tran.recurringTransaction // I think this is a pointer and not a value so if this is changed then it will probably transfer to this
    }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
