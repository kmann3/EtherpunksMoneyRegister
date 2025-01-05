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
    #if !DEBUG
        var container: ModelContainer = {
            let schema = Schema([
                Account.self,
                AccountTransaction.self,
                RecurringGroup.self,
                RecurringTransaction.self,
                TransactionFile.self,
                TransactionTag.self,
            ])
            // There is a problem with TransactionFile.Data and NOT being stored in memory.
            let config = ModelConfiguration(isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [config])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
    #endif

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if DEBUG
            .modelContainer(Previewer().container)
        #else
            .modelContainer(container)
        #endif
    }
}
