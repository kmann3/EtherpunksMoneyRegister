//
//  AccountListView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/12/24.
//

import SwiftUI

struct AccountListView: View {
    @EnvironmentObject var appContainer: LocalAppStateContainer
    @Binding var tabSelection: Tab

    @State var accounts: [AccountListViewItemData] = []

    var body: some View {
        List {
            Text("Account List")
            ForEach(accounts) { item in
                Text("ACC: \(item.account.name)")
            }

        }
        .onAppear() {
            // Get Data
            self.accounts = AccountListViewItemData.getAllAccountData(appContainer: appContainer)
        }
        .refreshable {
            self.accounts = AccountListViewItemData.getAllAccountData(appContainer: appContainer)
        }
    }
}

#Preview {
    var container = LocalAppStateContainer()
    container.loadedUserDbPath = "/Users/kennithmann/Downloads/testMoney_sqlite.mmr"
    container.recentFileEntries.append(RecentFileEntry(path: container.loadedUserDbPath!))
    container.appDbPath = container.getAppDbPath()

    var accounts: [AccountListViewItemData] = []

    return AccountListView(tabSelection: .constant(.accounts), accounts: accounts)
        .environmentObject(container)
}
