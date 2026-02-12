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
