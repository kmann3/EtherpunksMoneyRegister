//
//  AppSettings.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 6/8/24.
//

import Foundation
import SwiftData
import SwiftUI

/// Should this class be in user settings?
@Model
final class AppSettings {
    var notificationsEnabled: Bool = true
    var lastMobileFileUrl: String = ""
    var lastDesktopFileUrl: String = ""

    // TBI: Language / currency defaults?
    // var language: String

    @Relationship(deleteRule: .noAction)
    var defaultAccount: Account?

    init(notificationsEnabled: Bool, defaultAccount: Account? = nil) {
        self.notificationsEnabled = notificationsEnabled
        self.defaultAccount = defaultAccount
    }
}
