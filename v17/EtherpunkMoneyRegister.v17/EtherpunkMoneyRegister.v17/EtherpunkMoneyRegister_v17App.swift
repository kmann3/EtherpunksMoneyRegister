//
//  EtherpunkMoneyRegister_v17App.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/12/26.
//

import SwiftUI
import SwiftData

@main
struct EtherpunkMoneyRegister_v17App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Account.self,
            AccountTransaction.self,
            RecurringGroup.self,
            RecurringTransaction.self,
            TransactionFile.self,
            TransactionTag.self
        ])
        
        let mC = ModelConfiguration(cloudKitDatabase: .automatic)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [mC])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
