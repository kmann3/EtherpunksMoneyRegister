//
//  Tag.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class UserPrefs: Identifiable, Hashable {
    @Attribute(.unique) public var id: String = UUID().uuidString
    public var afterReserveGoToRaw: String = NavView.dashboard.rawValue
    @Transient public var afterReserveGoTo: NavView {
        get { NavView(rawValue: afterReserveGoToRaw) ?? .dashboard }
        set { afterReserveGoToRaw = newValue.rawValue }
    }
    
    init() {
    }
}

@MainActor
extension UserPrefs: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
            UserPrefs:
            - id: \(id)
            - afterReserveGoTo: \(afterReserveGoTo)
            """
    }
}
