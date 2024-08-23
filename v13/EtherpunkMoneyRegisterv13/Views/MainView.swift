//
//  MainView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/18/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appContainer: LocalAppStateContainer
    @State var tabSelection: Tab = .accounts
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            TabView(selection: $tabSelection) {
                VStack {
                    AccountListView(tabSelection: $tabSelection)
                        .tabItem {
                            Label("Accounts", systemImage: "house.lodge")
                        }
                        .tag(Tab.accounts)
                    //Spacer()
                    //Text("File: \(appContainer.loadedUserDbPath ?? "")")
                }
                Text("Metadata")
                    .tabItem {
                        Label("Metadata", systemImage: "list.bullet.clipboard")
                    }
                    .tag(Tab.metadata)
                Text("Reports")
                    .tabItem {
                        Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                    }
                    .tag(Tab.reports)
                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(Tab.settings)
            }
        }
        .navigationDestination(for: NavData.self) { item in
            switch item.navView {
            case .accountCreator:
                //EditAccountDetailsView(account: Account(name: "", startingBalance: 0), path: $path)
                Text("Account Creator")
            case .accountEditor:
                Text("Account Editor")
            case .accountList:
                // We should not be here?
                Text("We should not be here.")
            case .accountDeletor:
                Text("Delete account with transaction count > 0")

            case .recurringTransactionDetail:
                Text("Recurring Transaction Detail")
            case .recurringTransactionEditor:
                Text("Recurring Transaction Editor")
            case .recurringTransactionList:
                Text("Recurring Transaction List")

            case .recurringTransactionGroupDetail:
                Text("Recurring Transaction Group Detail")
            case .recurringTransactionGroupEditor:
                Text("Recurring Transaction Group Editor")
            case .recurringTransactionGroupList:
                Text("Recurring Transaction Group List")

            case .tagDetail:
                Text("Tag detail")

            case .tagEditor:
                Text("Tag Editor")

            case .transactionCreator:
                Text("Transaction Editor")

            case .transactionDetail:
                Text("Transaction Detail")

            case .transactionEditor:
                Text("Transaction Editor")

            case .transactionList:
                Text("Transaction List")

            }
        }
    }
}

#Preview {
    var container = LocalAppStateContainer()
    container.loadedUserDbPath = "/Users/kennithmann/Downloads/testMoney_sqlite.mmr"
    container.recentFileEntries.append(RecentFileEntry(path: container.loadedUserDbPath!))
    container.recentFileEntries.append(RecentFileEntry(path: container.loadedUserDbPath!))
    container.recentFileEntries.append(RecentFileEntry(path: container.loadedUserDbPath!))
    container.appDbPath = container.getAppDbPath()

    return MainView()
        .environmentObject(container)
}
