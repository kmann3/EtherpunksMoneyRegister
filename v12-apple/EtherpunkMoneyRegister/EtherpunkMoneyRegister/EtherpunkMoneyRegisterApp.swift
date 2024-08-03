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
    @StateObject var appStateContainer = AppStateContainer()
    var container: ModelContainer
    var previewer: Previewer

    init() {
        try! self.previewer = Previewer()
        let schema = Schema([
            Account.self,
            AccountTransaction.self,
            TransactionFile.self,
            AppSettings.self,
            TransactionTag.self,
            RecurringTransaction.self,
            RecurringTransactionGroup.self,
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: [configuration])
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateContainer)
                .environmentObject(appStateContainer.tabViewState)
        }
        .modelContainer(previewer.container)
//        .commands {
//            CommandGroup(replacing: .newItem) {
//                            Button("New") {}
//                            Button("Open") {}
//                            
//                            Divider()
//
//                            Button("Save As") {}
//                            Divider()
//
//                            Menu("Export") {
//                            Button("Excel") {}
//                            Button("CSV") {}
//                        }
//                    }
//                }
    }
}
