//
//  AppWideState.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 8/3/24.
//

import Foundation

class AppStateContainer: ObservableObject {
    var tabViewState = TabViewState()
    var loadedSqliteDbPath: String = ""
}

class TabViewState: ObservableObject {
    @Published var selectedTab: Tab = .accounts
}
