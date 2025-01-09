//
//  ext.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/29/24.
//

import Foundation
import SwiftData

extension Double {
    func toDecimal() -> Decimal {
        return Decimal(self)
    }
}

extension Decimal {
    func toDouble() -> Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}

extension Date {
    func toSummaryDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d - EEE")
        return dateFormatter.string(from: self)
    }

    func toSummaryDate2() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM d y")
        return dateFormatter.string(from: self)
    }

    func toDebugDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate(
            "EEE, dd MMM yyyy HH:mm:ssZ")
        return dateFormatter.string(from: self)
    }
}

extension ModelContext {
    var sqliteLocation: String {
        if let url = container.configurations.first?.url.path(
            percentEncoded: false)
        {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
