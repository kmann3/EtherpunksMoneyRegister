//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            Text("Dashboard View")
            Text("Current Available Spending")
            Text("Reserved Transactions:")
            Text("Pending Transactions:")
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(Previewer().container)
        .environment(PathStore())
        #if os(macOS)
            .frame(width: 900, height: 500)
        #endif
}
