//
//  EtherpunkMoneyRegisterv13App.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 7/19/24.
//

import SwiftUI

@main
struct EtherpunkMoneyRegisterv13App: App {
    var appContainer: LocalAppStateContainer = LocalAppStateContainer()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appContainer)
        }
    }
}
