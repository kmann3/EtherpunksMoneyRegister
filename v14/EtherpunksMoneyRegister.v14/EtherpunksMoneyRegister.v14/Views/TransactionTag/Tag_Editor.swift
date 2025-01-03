//
//  Tag_Editor.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 12/30/24.
//

import SwiftUI

struct TagEditor: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    @State private var viewModel: ViewModel

    init(tag: TransactionTag) {
        viewModel = ViewModel(tagToLoad: tag)
    }

    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.tagName)

            if viewModel.isNewTransaction == false {
                HStack {
                    Text("Created on:")
                    Text(
                        viewModel.tag.createdOnUTC,
                        format: .dateTime.month().day().year()
                    )
                    Text("@")
                    Text(viewModel.tag.createdOnUTC, format: .dateTime.hour().minute())
                }
            }

            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        viewModel.saveTag(modelContext: modelContext)
                        dismiss()
                    }
                }
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }

            ToolbarItem(placement: .destructiveAction) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteTag(modelContext: modelContext)
                    dismiss()
                }
                .disabled(viewModel.isNewTransaction)
                .opacity(viewModel.isNewTransaction ? 0 : 1)
            }

        }
        .confirmationDialog(
            "Delete Confirmation",
            isPresented: $viewModel.isShowingDeleteAlert
        ) {
            Button("Yes") { viewModel.deleteTag(modelContext: modelContext) }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete \(viewModel.tag.name)")
        }
    }
}

#Preview {
    let p = Previewer()
    TagEditor(tag: p.streamingTag)
        .modelContainer(p.container)
}
