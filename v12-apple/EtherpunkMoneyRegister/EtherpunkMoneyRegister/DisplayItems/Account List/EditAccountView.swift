//
//  EditAccountView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/21/24.
//

import SwiftUI

struct EditAccountView: View {
    
    @Environment(\.modelContext) var modelContext
    @Binding var path: NavigationPath
    @Bindable var account: Account
    
    
    var body: some View {
        Form {
            TextField("Name", text: $account.name)
            TextField("Amount", value: $account.startingBalance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
        }
        .navigationTitle("New Account")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            Button {
                // Save
                account.currentBalance = account.startingBalance
                path.removeLast()
            } label: {
                Text("Save")
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return EditAccountView(path: .constant(NavigationPath()), account: previewer.cuAccount)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
