//
//  0_FirstRunOverview.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 10/5/24.
//

import SwiftUI

struct FirstRunOverview: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            Text("Test")
            TabView {
                AccountSetup()
                IncomeSetup()
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .background(
            colorScheme == .dark ? Color.darkGray : Color.lightGray
        )
    }
}

extension Color {
    static let lightGray = Color(
        uiColor: UIColor.lightGray
    )
    static let darkGray = Color(
        uiColor: UIColor.darkGray
    )
}

#Preview {
    FirstRunOverview()
}
