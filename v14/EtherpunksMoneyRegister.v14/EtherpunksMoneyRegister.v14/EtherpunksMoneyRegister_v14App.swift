//
//  EtherpunksMoneyRegister_v14App.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 10/14/24.
//

import SwiftUI
import SwiftData

@main
struct EtherpunksMoneyRegister_v14App: App {
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
