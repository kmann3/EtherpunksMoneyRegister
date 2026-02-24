//
//  SidebarView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/12/26.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selection: PathStore.Route?
    let accounts: [Account]
    let onAction: (PathStore.Route) -> Void
    
    var body: some View {
        List(selection: $selection) {
            NavigationLink(value: PathStore.Route.dashboard) {
                Text("Dashboard")
            }

            NavigationLink(value: PathStore.Route.recurringGroup_List(recGroup: nil)) {
                Text("Recurring Groups")
            }

            NavigationLink(value: PathStore.Route.recurringTransaction_List(recTran: nil)) {
                Text("Recurring Transactions")
            }

            NavigationLink(value: PathStore.Route.tag_List(tag: nil)) {
                Text("Tags")
            }

            NavigationLink(value: PathStore.Route.settings) {
                Text("Settings")
            }

            NavigationLink(value: PathStore.Route.search) {
                Text("Search")
            }

            Section(header: Text("Accounts")) {
                Button("New Account"){
                    self.onAction(.account_Create)
                }
                
                if self.accounts.count == 0 {
                    Text("No accounts found. Create one above.")
                } else {
                    ForEach(self.accounts, id: \.id) { account in
                        HStack {
                            Button(account.name) {
                                self.onAction(.transaction_List(account: account))
                            }
                            .font(.title3)
                            .buttonStyle(.borderless)
                            Spacer()
                            Button("Add Credit", systemImage: "plus.circle"){
                                self.onAction(.transaction_Create(transaction: AccountTransaction(account: account, transactionType: .credit)))
                            }
                            .labelStyle(.iconOnly)
                            .buttonStyle(.plain)
                            .foregroundStyle(Color(.green))
                            Button("Add Debit", systemImage: "plus.circle"){
                                self.onAction(.transaction_Create(transaction: AccountTransaction(account: account, transactionType: .debit)))
                            }
                            .foregroundStyle(Color(.red))
                            .labelStyle(.iconOnly)
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .headerProminence(.increased)
        }
    }
}

struct SidebarPreviewContainer: View {
    @State var selection: PathStore.Route? = .dashboard
    var body: some View {
        SidebarView(
            selection: $selection,
            accounts: [],
            onAction: { _ in }
        )
        .frame(width: 220, height: 600)
    }
}

struct SidebarPreviewWithMockAccount: View {
    @State var selection: PathStore.Route? = .dashboard
    var body: some View {
        SidebarView(
            selection: $selection,
            accounts: [MoneyDataSource.shared.previewer.bankAccount],
            onAction: { _ in }
        )
        .frame(width: 280, height: 600)
    }
}

#Preview("Sidebar with no accounts") {
    SidebarPreviewContainer()
}

#Preview("Sidebar with Mock Account") {
    SidebarPreviewWithMockAccount()
}
