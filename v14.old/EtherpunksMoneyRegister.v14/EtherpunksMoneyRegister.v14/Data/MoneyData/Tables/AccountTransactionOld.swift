//
//  AccountTransaction.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import Foundation
import SwiftUI

final class AccountTransactionOld : ObservableObject, CustomDebugStringConvertible, Identifiable  {
    public var id: UUID = UUID()
    public var name: String = ""
    public var transactionType: TransactionType = TransactionType.debit
    public var amount: Decimal = 0
    public var balance: Decimal? = nil

    public var pendingLocal: Date? {
        get {
            if _pendingDateUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _pendingDateUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _pendingDateUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _pendingDateUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var pendingLocalString: String {
        get {
            if pendingLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return pendingLocal!.formatted()
            }
        }
    }

    public var clearedLocal: Date? {
        get {
            if _clearedDateUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _clearedDateUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _clearedDateUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _clearedDateUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var clearedLocalString: String {
        get {
            if clearedLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return clearedLocal!.formatted()
            }
        }
    }

    public var notes: String = ""
    public var confirmationNumber: String = ""
    public var recurringTransactionId: UUID? = nil
    public var dueDate: Date? = nil
    public var dueDateLocal: Date? {
        get {
            if _dueDateUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _dueDateUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _dueDateUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _dueDateUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var dueDateLocalString: String {
        get {
            if dueDateLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return dueDateLocal!.formatted()
            }
        }
    }

    public var isTaxRelated: Bool = false
    public var files: [TransactionFile]? = nil
    public var filesCount: Int = 0
    public var accountId: UUID
    public var transactionTags: [TransactionTag]? = nil
    public var balancedOnLocal: Date? {
        get {
            if _balancedOnUTC == nil {
                return nil
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

                if let utcDate = utcDateFormatter.date(from: _balancedOnUTC!) {
                    // Convert UTC Date to local time Date
                    let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                    return Date(timeIntervalSinceReferenceDate: localTimeInterval)
                } else {
                    debugPrint("Failed to convert UTC string to Date object.")
                    return nil
                }
            }
        }
        set {
            // Convert local time to UTC
            if newValue == nil {
                _balancedOnUTC = ""
            } else {
                let utcDateFormatter = DateFormatter()
                utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                _balancedOnUTC = utcDateFormatter.string(from: newValue!)
            }
        }
    }

    public var balancedOnLocalString: String {
        get {
            if balancedOnLocal == nil {
                return ""
            } else {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                formatter.timeZone = .current
                return balancedOnLocal!.formatted()
            }
        }
    }

    /// The background color indicating the status of the transaction.
    public var backgroundColor: Color {
        switch self.transactionStatus {
        case .cleared:
            Color.clear
        case .pending:
            Color(.sRGB, red: 255/255, green: 150/255, blue: 25/255, opacity: 0.5)
        case .reserved:
            Color(.sRGB, red: 255/255, green: 25/255, blue: 25/255, opacity: 0.5)
        }
    }

    /// The inferred status of the transaction.
    public var transactionStatus: TransactionStatus {
        if self.pendingLocal == nil && self.clearedLocal == nil {
            return .reserved
        } else if self.pendingLocal != nil && self.clearedLocal == nil {
            return .pending
        } else {
            return .cleared
        }
    }

    public var createdOnLocal: Date {
        get {
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            if let utcDate = utcDateFormatter.date(from: _createdOnUTC) {
                // Convert UTC Date to local time Date
                let localTimeInterval = utcDate.timeIntervalSinceReferenceDate + TimeInterval(TimeZone.current.secondsFromGMT(for: utcDate))
                return Date(timeIntervalSinceReferenceDate: localTimeInterval)
            } else {
                debugPrint("Failed to convert UTC string to Date object.")
                return Date()
            }
        }
        set {
            // Convert local time to UTC
            let utcDateFormatter = DateFormatter()
            utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            _createdOnUTC = utcDateFormatter.string(from: newValue)
        }
    }

    public var createdOnLocalString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            formatter.timeZone = .current
            return createdOnLocal.formatted()
        }
    }

    public var debugDescription: String {
        return """
            AccountTransaction:
            -  id: \(id)
            -  accountId: \(accountId)
            -  name: \(name)
            -  transactionType: \(transactionType)
            -  amount: \(amount)
            -  balance: \(String(describing: balance))
            -  pendingUTC: \(String(describing: _pendingDateUTC))
            -  pendingLocal: \(pendingLocalString)
            -  name: \(name)
            -  name: \(name)
            -  notes: \(notes)
            -  createdOnLocal: \(createdOnLocal)
            -  createdOnLocalString: \(createdOnLocalString)
            -  _createdOnUTC: \(_createdOnUTC)
            """
    }

    private var _pendingDateUTC: String? = ""
    private var _clearedDateUTC: String? = ""
    private var _dueDateUTC: String? = ""
    private var _balancedOnUTC: String? = ""
    private var _createdOnUTC: String = ""

    init(id: UUID = UUID(), accountId: UUID, name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal? = nil, pendingLocal: Date? = nil, clearedLocal: Date? = nil, notes: String = "", confirmationNumber: String = "", recurringTransactionId: UUID? = nil, files: [TransactionFile]? = [], transactionTags: [TransactionTag]? = [], isTaxRelated: Bool = false, dueDateLocal: Date? = nil, balancedOnLocal: Date? = nil, createdOnLocal: Date = Date()) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self.pendingLocal = pendingLocal
        self.clearedLocal = clearedLocal
        self.notes = notes
        self.confirmationNumber = confirmationNumber
        self.recurringTransactionId = recurringTransactionId
        self.dueDateLocal = dueDateLocal
        self.isTaxRelated = isTaxRelated
        self.files = files
        self.transactionTags = transactionTags
        self.balancedOnLocal = balancedOnLocal
        self.createdOnLocal = createdOnLocal

        self.VerifySignage()
    }

    init(id: UUID = UUID(), accountId: UUID, name: String = "", transactionType: TransactionType = .debit, amount: Decimal = 0, balance: Decimal? = nil, pendingUTC: String? = nil, clearedUTC: String? = nil, notes: String = "", confirmationNumber: String = "", recurringTransactionId: String? = nil, files: [TransactionFile]? = [], transactionTags: [TransactionTag]? = [], isTaxRelated: Bool = false, dueDateUTC: String?, balancedOnUTC: String?, createdOnUTC: String) {
        self.id = id
        self.accountId = accountId
        self.name = name
        self.transactionType = transactionType
        self.amount = amount
        self.balance = balance
        self._pendingDateUTC = pendingUTC
        self._clearedDateUTC = clearedUTC
        self.notes = notes
        self.confirmationNumber = confirmationNumber

        let recTranId: String?  = recurringTransactionId
        var recTranIdUUID: UUID? = nil
        if recTranId != nil {
            recTranIdUUID = UUID.init(uuidString: recurringTransactionId!)
        }

        self.recurringTransactionId = recTranIdUUID
        self._dueDateUTC = dueDateUTC
        self.isTaxRelated = isTaxRelated
        self.files = files
        self.transactionTags = transactionTags
        self._balancedOnUTC = balancedOnUTC
        self._createdOnUTC = createdOnUTC

        self.VerifySignage()
    }

    func VerifySignage() {
        switch self.transactionType {
        case .credit:
            self.amount = abs(self.amount)
        case .debit:
            self.amount = -abs(self.amount)
        }
    }
}
