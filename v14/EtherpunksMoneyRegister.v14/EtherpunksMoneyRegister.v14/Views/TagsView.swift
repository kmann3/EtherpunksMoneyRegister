//
//  TagsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftUI
import SwiftData

struct TagsView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\TransactionTag.name, comparator: .localizedStandard)]) var tags: [TransactionTag]

    var body: some View {
        List {
            Section(header: Text("Transaction Tags"), footer: Text("End of list")) {
                ForEach(tags.sorted(by: { $0.name < $1.name })) { transactionTag in
                    TransactionTagItemView(transactionTag: transactionTag)
                }
            }
        }
        .refreshable {
            // TODO: Implement tag refresh
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
    let p = Previewer()
    TagsView()
        .modelContainer(p.container)
}
