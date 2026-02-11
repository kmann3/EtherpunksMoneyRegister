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

            Divider()

            Section(header: Text("Accounts")) {
                Button("New Account"){
                    self.onAction(.account_Create)
                }

                ForEach(self.accounts, id: \.id) { account in
                    HStack {
                        NavigationLink(value: PathStore.Route.transaction_List(account: account)) {
                            Text(account.name)
                        }
                        Spacer()
                        Button("Add Transaction", systemImage: "plus.circle"){
                            // Popup menu for adding credit/debit transaction
                        }
                        .labelStyle(.iconOnly)
                        .buttonStyle(.plain)
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

#Preview("Sidebar with Mock Account") {
    SidebarPreviewWithMockAccount()
}

