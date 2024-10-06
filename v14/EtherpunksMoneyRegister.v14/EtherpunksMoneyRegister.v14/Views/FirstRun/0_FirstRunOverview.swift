//
//  0_FirstRunOverview.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 10/5/24.
//

import SwiftUI

struct FirstRunOverview: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedTab = "Account Setup"
    @State private var nextActionTab = "Swipe to the left to continue"

    var body: some View {
        VStack {
            Text(selectedTab)
            TabView()  {
                AccountSetup()
                    .onAppear() {
                        selectedTab = "Account Setup"
                    }
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("Accounts")
                    }
                 IncomeSetup()
                    .onAppear() {
                        selectedTab = "Income Setup"
                    }
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("Income")
                    }
                 RecurringExpensesSetup()
                    .onAppear() {
                        selectedTab = "Expense Setup"
                    }
                    .tabItem {
                        Image(systemName: "4.circle")
                        Text("Expenses")
                    }
                 TagsSetup()
                    .onAppear() {
                        selectedTab = "Suggested Tags"
                        nextActionTab = "Setup complete.\nSwipe to the left to begin using the app."
                    }
                    .tabItem {
                        Image(systemName: "5.circle")
                        Text("Tags")
                    }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            Text(nextActionTab)

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
