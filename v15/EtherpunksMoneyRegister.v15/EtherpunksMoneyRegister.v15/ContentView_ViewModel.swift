//
//  ContentView_ViewModel.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 1/21/25.
//
import Swift
import SwiftUI

extension ContentView {

    @Observable
    class ViewModel {

        @ObservationIgnored
        private let dataSource: MoneyDataSource

        var pathStore: PathStore

        @MainActor
        init(dataSource: MoneyDataSource = MoneyDataSource.shared) {
            self.dataSource = dataSource
            self.pathStore = MoneyDataSource.pathStore
        }
    }
}
