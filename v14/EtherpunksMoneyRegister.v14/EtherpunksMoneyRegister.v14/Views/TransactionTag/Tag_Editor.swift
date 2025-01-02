//
//  Tag_Editor.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 12/30/24.
//

import SwiftUI

struct TagEditor: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) var modelContext

    @State private var viewModel: ViewModel

    init(tag: TransactionTag) {
        viewModel = ViewModel(tagToLoad: tag)
    }

    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.tagName)

            HStack {
                Text("Created on:")
                Text(
                    viewModel.tag.createdOnUTC,
                    format: .dateTime.month().day().year()
                )
                Text("@")
                Text(viewModel.tag.createdOnUTC, format: .dateTime.hour().minute().second())
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        viewModel.saveTag(modelContext: modelContext)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    let p = Previewer()
    TagEditor(tag: p.streamingTag)
        .modelContainer(p.container)
}
