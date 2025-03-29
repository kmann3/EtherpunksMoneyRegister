//
//  TagListView.swift
//  EtherpunksMoneyRegister.v15
//
//  Created by Kennith Mann on 3/11/25.
//

import SwiftUI

struct TagListView: View {
    var viewModel: ViewModel
    var handler: (PathStore.Route) -> Void

    init(selectedTag: TransactionTag? = nil, _ handler: @escaping (PathStore.Route) -> Void) {
        self.viewModel = ViewModel(selectedTag: selectedTag)
        self.handler = handler
    }

    var body: some View {
        List {
            HStack {
                Text("Tags")
                    .bold(true)
                    .font(.title)
                Spacer()
                Button {
                    handler(PathStore.Route.tag_Create)
                } label: {
                    Text("+")
                }
            }
            ForEach(self.viewModel.tags, id: \.id) { tag in
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
                .background(self.viewModel.selectedTag?.id == tag.id ? Color.blue.opacity(0.3) : Color.clear)

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
