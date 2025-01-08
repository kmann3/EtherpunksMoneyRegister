//
//  EtherpunksMoneyRegister_v14App.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/15/24.
//

import SwiftData
import SwiftUI

@main
struct EtherpunksMoneyRegister_v14App: App {
    var container: ModelContainer

    init() {
        container = {
            let schema = Schema([
                Account.self,
                AccountTransaction.self,
                RecurringGroup.self,
                RecurringTransaction.self,
                TransactionFile.self,
                TransactionTag.self
            ])

            let config = ModelConfiguration(isStoredInMemoryOnly: false)

            do {

                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("fatal error: Could not create ModelContainer: \(error)")
            }
        }()

        print("-----------------")
        print(Date().toDebugDate())
        print("-----------------")
        print("Database Location: \(container.mainContext.sqliteLocation)")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
        //.modelContext(container.mainContext)

    }
}
