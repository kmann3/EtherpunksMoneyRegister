//
//  ReportsView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 6/18/24.
//

import SwiftUI

struct ReportsView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()

    var body: some View {
        List {
            Button("Tax Information") {}
            Button("Statistics") {}
        }
    }
}

#Preview {
    ReportsView()
}
