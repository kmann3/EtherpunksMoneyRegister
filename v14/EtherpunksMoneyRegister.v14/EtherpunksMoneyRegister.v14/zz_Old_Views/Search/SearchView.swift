//
//  SearchView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.modelContext) var modelContext

    var searchText: String

    init(searchText: String = "") {
        self.searchText = searchText
    }

    var body: some View {
        Text("Search View")
    }
}

#Preview {
    SearchView(searchText: "Test")
}
