//
//  EtherpunkMoneyRegisterApp.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftData
import SwiftUI

@main
struct EtherpunkMoneyRegisterApp: App {
    var container: ModelContainer
    var previewer: Previewer

    init() {
        try! self.previewer = Previewer()
        let schema = Schema([
            Account.self,
            AccountTransaction.self,
            AccountTransactionFile.self,
            AppSettings.self,
            Tag.self,
            RecurringTransaction.self,
            RecurringTransactionGroup.self,
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: [configuration])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(previewer.container)
    }
}
