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
            ForEach(accounts) { item in
                AccountListItemView(acctData: item)
                    .contextMenu {
                        Button {
                            balanceAccount(account: item)
                        } label: {
                            Label("Set Balanced to Now", systemImage: "square.and.arrow.down")
                        }

                        Button {
                            editAccount(account: item)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
            }

        }
        .onAppear() {
            if self.accounts.count == 0 {
                self.accounts = AccountListViewItemData.getAllAccountData(appContainer: appContainer)
            }
        }
        .refreshable {
            self.accounts = AccountListViewItemData.getAllAccountData(appContainer: appContainer)
        }
    }

    func balanceAccount(account: AccountListViewItemData) {
        debugPrint("Balanced now: \(account.account.name)")
    }

    func editAccount(account: AccountListViewItemData) {
        debugPrint("Edit Account: \(account.account.name)")
    }
}

#Preview {
    var container = LocalAppStateContainer()
    container.loadedUserDbPath = "/Users/kennithmann/Downloads/testMoney_sqlite.mmr"
    container.recentFileEntries.append(RecentFileEntry(path: container.loadedUserDbPath!))
    container.appDbPath = container.getAppDbPath()

    var accounts: [AccountListViewItemData] = [
        AccountListViewItemData(account: Previewer.bankAccount, transactionCount: 5),
                                               AccountListViewItemData(account: Previewer.bankAccount, transactionCount: 51291)]

    return AccountListView(tabSelection: .constant(.accounts), accounts: accounts)
        .environmentObject(container)
}
