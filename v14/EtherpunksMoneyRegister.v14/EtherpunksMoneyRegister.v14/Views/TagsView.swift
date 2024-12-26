//
//  TagsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI

struct TagsView: View {
    var tags: [TransactionTag] = []

    init() {
        let p: Previewer = Previewer()
        self.tags = [
            p.billsTag,
            p.ffTag,
            p.incomeTag,
            p.medicalTag,
            p.streamingTag
        ]
    }

    var body: some View {
        List {
            Section(header: Text("Transaction Tags"), footer: Text("End of list")) {
                ForEach(tags.sorted(by: { $0.name < $1.name })) { transactionTag in
                    TransactionTagItemView(transactionTag: transactionTag)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        //path.append(NavData(navView: .transactionEditor, transaction: transactionItem))
                    } label: {
                        Label("New Tag", systemImage: "pencil")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
    }
}

#Preview {
    TagsView()
}
