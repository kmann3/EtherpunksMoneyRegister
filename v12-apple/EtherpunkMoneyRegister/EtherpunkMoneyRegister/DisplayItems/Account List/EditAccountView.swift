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
        Text(account.name)
        Text(account.id.uuidString)
        Text(account.createdOn.ISO8601Format())
            .toolbar {
                Button {
                    // Save
                    path.removeLast()
                } label: {
                    Text("Save")
                }
            }
    }
}
