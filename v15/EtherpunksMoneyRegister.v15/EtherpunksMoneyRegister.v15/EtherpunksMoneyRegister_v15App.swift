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
#if os(macOS)
                .frame(minWidth: 1100, minHeight: 750)
#endif
        }
        .modelContainer(MoneyDataSource.shared.modelContainer)

    }
}
