//
//  TagEditorView.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/10/25.
//

import SwiftUI

struct TagEditorView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: ViewModel

    init(tag: TransactionTag) {
        viewModel = ViewModel(tag: tag)
    }

    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.tagName)
                .padding(15)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            Color(
                                .sRGB, red: 125 / 255, green: 125 / 255,
                                blue: 125 / 255, opacity: 0.5))
                )

            if viewModel.isNewTag == false {
                HStack {
                    Text("Created on:")
                    Text(
                        viewModel.tag.createdOnUTC,
                        format: .dateTime.month().day().year()
                    )
                    Text("@")
                    Text(
                        viewModel.tag.createdOnUTC,
                        format: .dateTime.hour().minute())
                }
            }

            Spacer()
        }
        .contentShape(Rectangle())
        .navigationTitle("Edit Tag")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        viewModel.saveTag()
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
                    viewModel.deleteTag()
                    dismiss()
                }
                .disabled(viewModel.isNewTag)
                .opacity(viewModel.isNewTag ? 0 : 1)
            }

        }
        .confirmationDialog(
            "Delete Confirmation",
            isPresented: $viewModel.isShowingDeleteAlert
        ) {
            Button("Yes") { viewModel.deleteTag() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete \(viewModel.tag.name)")
        }
    }
}

#Preview("New Tag") {
    TagEditorView(tag: TransactionTag(name: ""))
}

#Preview("Existing Tag") {
    TagEditorView(tag: Previewer().billsTag)
}
