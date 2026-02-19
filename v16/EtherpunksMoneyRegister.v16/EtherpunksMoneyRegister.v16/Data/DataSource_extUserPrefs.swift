//
//  DataSource_extTag.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/15/26.
//

import Foundation
import SwiftData

extension MoneyDataSource {
    func fetchUserPrefs() -> UserPrefs {
        // TODO: Singleton and share once pulled the first time?
        do {
            return try modelContext.fetch(FetchDescriptor<UserPrefs>()).first!
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
