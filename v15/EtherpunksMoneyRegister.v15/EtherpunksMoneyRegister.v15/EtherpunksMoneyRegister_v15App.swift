//
//  EtherpunksMoneyRegister_v15App.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//

import SwiftUI
import SwiftData

@main
struct EtherpunksMoneyRegister_v15App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 1200, height: 750)
        .windowResizability(.contentMinSize)
        #endif
        .modelContainer(MoneyDataSource.shared.modelContainer)

    }
}
