//
//  EtherpunkMoneyRegisterv14App.swift
//  EtherpunkMoneyRegisterv14
//
//  Created by Kennith Mann on 9/26/24.
//

import SwiftUI
import SwiftData

@main
struct EtherpunkMoneyRegisterv14App: App {
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
