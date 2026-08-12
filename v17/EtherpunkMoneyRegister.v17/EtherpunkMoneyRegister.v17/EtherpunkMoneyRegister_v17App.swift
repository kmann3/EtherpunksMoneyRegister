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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 1200, height: 750)
        .windowResizability(.contentMinSize)
        #endif
        .modelContainer(DataSource.shared.modelContainer)
    }
}

