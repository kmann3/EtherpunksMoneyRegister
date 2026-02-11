//
//  EtherpunksMoneyRegister_v16App.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/11/26.
//

import SwiftUI
import SwiftData

@main
struct EtherpunksMoneyRegister_v16App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
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
