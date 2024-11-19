//
//  ContentView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/15/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var searchText: String = ""
    @State var isShowing: Bool = true
    @State var selectedSideMenuTab = 0

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(MenuOptionsEnum.allCases, id: \.self) { row in
                    NavigationLink(destination: row.action) {
                        Label(row.title, systemImage: row.iconName)
                    }
                    .navigationSplitViewColumnWidth(100)
                }
            }
        } content: {
            Text("test")
                .navigationSplitViewColumnWidth(
                    min: 100,
                    ideal: 200,
                    max: .infinity
                )
        } detail: {
            Text("Preview and details")
                .navigationSplitViewColumnWidth(
                    min: 250,
                    ideal: 300,
                    max: .infinity
                )
        }
        .searchable(text: $searchText)

    }
}

#Preview {
    ContentView()
        //.modelContainer(for: Item.self, inMemory: true)
}
