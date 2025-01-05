//
//  TagsView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 11/19/24.
//

import SwiftData
import SwiftUI

struct TagsView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(PathStore.self) var router
    @Query(sort: [
        SortDescriptor(\TransactionTag.name, comparator: .localizedStandard)
    ])
    var tags: [TransactionTag]

    @State var viewModel: ViewModel = ViewModel()

    var body: some View {
        List {
            Section(
                header: Text("Transaction Tags"), footer: Text("End of list")
            ) {
                ForEach(tags.sorted(by: { $0.name < $1.name })) {
                    transactionTag in
                    TransactionTagItemView(transactionTag: transactionTag)
                        .contextMenu(menuItems: {
                            Button(
                                "Delete",
                                action: {
                                    viewModel.tagToDelete = transactionTag
                                    viewModel.isDeleteWarningPresented.toggle()

                                })
                        })
                        .onTapGesture {
                            router
                                .navigateTo(
                                    route: .tag_Edit(tag: transactionTag)
                                )
                        }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Menu {
                    Button {
                        router.navigateTo(route: .tag_Create)
                    } label: {
                        Label("New Tag", systemImage: "pencil")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .confirmationDialog(
            "Delete Confirmation",
            isPresented: $viewModel.isDeleteWarningPresented
        ) {
            Button("Yes") { viewModel.deleteTag() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(
                "Are you sure you want to delete \(viewModel.tagToDelete?.name ?? "none_selected")"
            )
        }
    }
}

#Preview {
    TagsView()
        .modelContainer(Previewer().container)
        .environment(PathStore())
}
