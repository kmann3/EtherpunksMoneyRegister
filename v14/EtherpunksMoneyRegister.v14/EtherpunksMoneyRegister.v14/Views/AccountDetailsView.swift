//
//  AccountDetailsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/23/24.
//

import SwiftUI

struct AccountDetailsView: View {
    @Binding var presenting: Bool
    var account: Account

    init(account: Account, presenting: Binding<Bool>) {
        self.account = account
        self._presenting = presenting
    }

    var body: some View {
        VStack {
            Text("Account Details View")
        }
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .destructiveAction, content: {
//                Button(action: {
//                    presenting = false
//                }, label: {
//                    Image(systemName: "chevron.left")
//                        .foregroundStyle(.secondary)
//                        .font(.title2)
//                        .frame(width: 20)
//                })
//                .buttonStyle(.automatic)
//            })
//
//            ToolbarItem(placement: .principal, content: {
//                Text("Account Details: \(account.name)")
//                    .font(.title3)
//            })
//        }
    }
}

#Preview {
    AccountDetailsView(account: Previewer.bankAccount, presenting: .constant(true))
}

//#if os(macOS)
//struct TestView: View {
//
//    var body: some View {
//        NavigationSplitView(sidebar: {
//            Sidebar()
//        }, content: {
//
//        }, detail: {
//
//        })
//    }
//}
//#endif
