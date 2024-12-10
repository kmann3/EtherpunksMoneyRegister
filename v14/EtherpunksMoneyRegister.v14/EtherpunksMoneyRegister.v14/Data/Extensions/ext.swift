//
//  ext.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/29/24.
//

import Foundation

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
}
