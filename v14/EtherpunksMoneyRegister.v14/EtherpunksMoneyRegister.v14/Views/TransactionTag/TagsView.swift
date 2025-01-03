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
    @Query(sort: [SortDescriptor(\TransactionTag.name, comparator: .localizedStandard)])
    var tags: [TransactionTag]
    
    @State var navPath: PathStore
    @State var viewModel: ViewModel = ViewModel()

    var body: some View {
        List {
            Section(header: Text("Transaction Tags"), footer: Text("End of list")) {
                ForEach(tags.sorted(by: { $0.name < $1.name })) { transactionTag in
                    NavigationLink(destination: TagEditor(tag: transactionTag)) {
                        TransactionTagItemView(transactionTag: transactionTag)
                            .contextMenu(menuItems: {
                                Button("Delete", action: {
                                    viewModel.tagToDelete = transactionTag
                                    viewModel.isDeleteWarningPresented.toggle()

                                })
                            })
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button {
                        viewModel.isPresented.toggle()
                    } label: {
                        Label("New Tag", systemImage: "pencil")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .sheet(
            isPresented: $viewModel.isPresented,
            content: { TagEditor(tag: TransactionTag(name: ""))
            })
        .confirmationDialog(
            "Delete Confirmation",
            isPresented: $viewModel.isDeleteWarningPresented
        ) {
            Button("Yes") { viewModel.deleteTag() }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(viewModel.tagToDelete!.name)")
        }
    }
}

#Preview {
    let p = Previewer()
    TagsView(navPath: PathStore())
        .modelContainer(p.container)
}
