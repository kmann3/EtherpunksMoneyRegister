//
//  EtherpunkMoneyRegisterApp.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftUI
import SwiftData

@main
struct EtherpunkMoneyRegisterApp: App {
    var container: ModelContainer
    
    init() {
        
        let schema = Schema([
            Account.self,
            AccountTransaction.self,
            AccountTransactionFile.self,
            AppSettings.self,
            Tag.self,
            RecurringTransaction.self,
            RecurringTransactionGroup.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: [configuration])
        
        #if DEBUG
        seedData(container: container)
        #endif
    }
        
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
    
    @MainActor
    func seedData(container: ModelContainer) {
        container.mainContext.insert(Tag(name: "test"))
        container.mainContext.insert(Account(name: "Test", startingBalance: 5))
        try? container.mainContext.save()
    }
}
