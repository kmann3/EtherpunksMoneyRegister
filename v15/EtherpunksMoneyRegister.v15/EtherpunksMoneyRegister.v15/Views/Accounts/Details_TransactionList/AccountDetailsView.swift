//
//  AccountDetailsView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 2/7/25.
//

import SwiftUI

struct AccountDetailsView: View {
    @State var viewModel: ViewModel

    init(account: Account) {
        viewModel = ViewModel(account: account)
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AccountDetailsView(account: Previewer().bankAccount)
}
