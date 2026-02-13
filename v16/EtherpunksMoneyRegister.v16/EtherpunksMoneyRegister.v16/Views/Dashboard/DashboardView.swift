//
//  DashboardView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
#if os(macOS)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
#endif
#if os(iOS)
    // TODO: Implement iOS Dashboard
    Text("iOS TBI")
#endif
    }
}

#Preview {
    DashboardView()
}
