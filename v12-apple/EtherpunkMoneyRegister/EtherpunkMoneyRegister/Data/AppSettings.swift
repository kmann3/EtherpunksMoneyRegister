//
//  AppSettings.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 6/8/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class AppSettings {
    var notificationsEnabled: Bool = true

    // TBI: Language / currency defaults?
    // var language: String

    @Relationship(deleteRule: .noAction)
    var defaultAccount: Account?

    init(notificationsEnabled: Bool, defaultAccount: Account? = nil) {
        self.notificationsEnabled = notificationsEnabled
        self.defaultAccount = defaultAccount
    }
}
