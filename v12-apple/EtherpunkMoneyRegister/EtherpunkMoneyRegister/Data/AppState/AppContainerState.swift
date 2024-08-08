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
    var defaultAccount: Account? = nil

    public func begin() {
        self.tabViewState = TabViewState()
        self.loadedSqliteDbPath = ""
        self.defaultAccount = nil
    }
}

class TabViewState: ObservableObject {
    @Published var selectedTab: Tab = .accounts
}
