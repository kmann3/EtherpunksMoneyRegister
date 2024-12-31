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

    @State var tag: TransactionTag
    @State var associatedTransactions: [AccountTransaction]?

    @State var tagName: String

    var isNewTransaction: Bool = false

    init(tag: TransactionTag) {
        self.tag = tag
        _tagName = State(initialValue: tag.name)

        if tag.name != "" {
            isNewTransaction = false
        }
    }

    var body: some View {
        VStack {
            TextField("Name", text: $tagName)

            HStack {
                Text("Created on:")
                Text(tag.createdOnUTC, format: .dateTime.month().day().year())
                Text("@")
                Text(tag.createdOnUTC, format: .dateTime.hour().minute().second())
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    withAnimation {
                        saveTag()
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

    func saveTag() {
        var hasChanges = false

        if(self.tag.name != _tagName.wrappedValue) {
            self.tag.name = _tagName.wrappedValue
                .trimmingCharacters(in: .whitespacesAndNewlines)
            hasChanges = true
        }

        if(hasChanges == false) {
            // do a popup? Saying no changes made?
        } else {
            do {
                if isNewTransaction {
                    modelContext.insert(self.tag)
                }

                try modelContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                debugPrint(error)
            }
        }
    }
}

#Preview {
    let p = Previewer()
    TagEditor(tag: p.streamingTag)
        .modelContainer(p.container)
}
