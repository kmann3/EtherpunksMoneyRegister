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
