//
//  TagPickerView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/18/26.
//

import SwiftUI
import SwiftData

struct TagPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \TransactionTag.name) private var allTags: [TransactionTag]
    @State private var selection: Set<TransactionTag.ID>
    var onDone: ([TransactionTag]) -> Void
    var onCancel: () -> Void

    init(initialSelection: [TransactionTag],
         onDone: @escaping ([TransactionTag]) -> Void,
         onCancel: @escaping () -> Void) {
        _selection = State(initialValue: Set(initialSelection.map { $0.id }))
        self.onDone = onDone
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationStack {
            List(allTags) { tag in
                HStack {
                    Text(tag.name)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { selection.contains(tag.id) },
                        set: { isOn in
                            if isOn { selection.insert(tag.id) } else { selection.remove(tag.id) }
                        }
                    ))
                    .labelsHidden()
                }
            }
            .navigationTitle("Select Tags")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        let chosen = allTags.filter { selection.contains($0.id) }
                        onDone(chosen)
                        dismiss()
                    }
                }
            }
        }
        .frame(width: 250, height: 250)
    }
}

#Preview {
    TagPickerView(initialSelection: [], onDone: { foo in }, onCancel: {})
}
