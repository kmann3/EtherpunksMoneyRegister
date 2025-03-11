//
//  TagListView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/11/25.
//

import SwiftUI

struct TagListView: View {
    var viewModel = ViewModel()
    var handler: (PathStore.Route) -> Void

    init(viewModel: TagListView.ViewModel = ViewModel(), _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = viewModel
        self.handler = handler
    }

    var body: some View {
        List {
            Text("Tags")
                .bold(true)
                .font(.title)
            ForEach(self.viewModel.tags, id: \.self) { tag in
                HStack {
                    Text("\(tag.name)")
                    Spacer()
                         Text("[Transactions:\(tag.accountTransactions?.count ?? 0) | Recurring:\(tag.recurringTransactions?.count ?? 0)]")

                }
                .onTapGesture { t in
                    handler(PathStore.Route.tag_Details(tag: tag))
                }
            }
        }
    }
}

#Preview {
    TagListView() { _ in }
}
