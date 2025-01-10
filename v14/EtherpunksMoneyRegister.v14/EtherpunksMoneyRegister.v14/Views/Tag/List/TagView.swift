//
//  TagView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/10/25.
//

import SwiftUI

struct TagView: View {
    @State var viewModel = ViewModel()

    var body: some View {
        List {
            Section(
                header: Text("Transaction Tags"), footer: Text("End of list")
            ) {
                ForEach(viewModel.tags.sorted(by: { $0.name < $1.name })) {
                    transactionTag in
                    TagItemView(transactionTag: transactionTag)
                        .contextMenu(menuItems: {
                            Button(
                                "Delete",
                                action: {
                                    viewModel.tagToDelete = transactionTag
                                    viewModel.isDeleteWarningPresented.toggle()

                                })
                        })
                        .onTapGesture {
                            viewModel.pathStore
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
                        viewModel.pathStore.navigateTo(route: .tag_Create)
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
    TagView()
}
