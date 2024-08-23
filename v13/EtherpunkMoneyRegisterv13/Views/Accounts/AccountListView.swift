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

    @State var accounts: [Account] = []

    var body: some View {
        List {
            ForEach(accounts) { item in
                Text("ACC: \(item.name)")
            }
            Text("Account List")
        }
        .onAppear() {
            // Get Data
            self.accounts = Account.getAllAccounts(appContainer: appContainer)
        }
        .refreshable {
            self.accounts = Account.getAllAccounts(appContainer: appContainer)
        }
    }
}

#Preview {
    var container = LocalAppStateContainer()
    container.loadedUserDbPath = "/Users/kennithmann/Downloads/testMoney_sqlite.mmr"
    container.recentFileEntries.append(RecentFileEntry(path: container.loadedUserDbPath!))
    container.appDbPath = container.getAppDbPath()

    var accounts: [Account] = []
    accounts.append(Account(name: "Test", startingBalance: 0, currentBalance: 0, outstandingBalance: 0, outstandingItemCount: 0, notes: ""))

    return AccountListView(tabSelection: .constant(.accounts), accounts: accounts)
        .environmentObject(container)
}
