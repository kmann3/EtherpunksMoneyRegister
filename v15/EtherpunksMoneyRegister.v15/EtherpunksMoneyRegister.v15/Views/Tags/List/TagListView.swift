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
                VStack {
                    HStack {
                        Text(tag.name)
                        Spacer()
                    }
                    HStack {
                        Text("\tTransaction #:\t\(tag.accountTransactions?.count ?? 0)")
                        Spacer()
                    }
                    #if os(macOS)
                    HStack {
                        Text("\tRecurring #:\t\t\(tag.recurringTransactions?.count ?? 0)")
                        Spacer()
                    }
                    #else
                    HStack {
                        Text("\tRecurring #:\t\(tag.recurringTransactions?.count ?? 0)")
                        Spacer()
                    }
                    #endif
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
