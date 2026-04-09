//
//  ReserveDraftItem.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/22/26.
//

import Foundation


public class ReserveDraft: Identifiable {
    public var id: UUID = .init()
    let recurringTransaction: RecurringTransaction
    var account: Account
    var name: String
    var transactionType: TransactionType
    var amount: Decimal
    var dueDate: Date?
    var isTaxRelated: Bool
    var tags: [TransactionTag]
    var notes: String = ""
    var action: Action = .enable

    init(from rec: RecurringTransaction) {
        self.recurringTransaction = rec
        self.account = rec.defaultAccount
        self.name = rec.name
        self.transactionType = rec.transactionType
        self.amount = rec.amount
        self.dueDate = rec.nextDueDate
        self.isTaxRelated = rec.isTaxRelated
        self.tags = rec.transactionTags
    }
}

enum Action {
    case enable
    case skip
    case ignore
}

@MainActor
extension ReserveDraft: CustomDebugStringConvertible {
    public var debugDescription: String {
        let due = dueDate.map { ISO8601DateFormatter().string(from: $0) } ?? "nil"
        let tagList = tags.map { $0.name }.joined(separator: ", ")
        let actionStr: String = {
            switch action {
            case .enable: return "enable"
            case .skip: return "skip"
            case .ignore: return "ignore"
            }
        }()
        return """
        ReserveDraftItem:
        - id: \(id)
        - recurringTransaction: \(recurringTransaction.name)
        - account: \(account.name)
        - name: \(name)
        - transactionType: \(transactionType)
        - amount: \(amount)
        - dueDate: \(due)
        - isTaxRelated: \(isTaxRelated)
        - tags: [\(tagList)]
        - notes: \(notes)
        - action: \(actionStr)
        """
    }
}

