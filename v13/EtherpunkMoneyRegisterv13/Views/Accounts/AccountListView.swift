//
//  AccountListView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 8/12/24.
//

import SwiftUI

struct AccountListView: View {

    @Binding var tabSelection: Tab

    var body: some View {
        Text("AccountListView")
    }
}

#Preview {
    AccountListView(tabSelection: .constant(.accounts))
}
