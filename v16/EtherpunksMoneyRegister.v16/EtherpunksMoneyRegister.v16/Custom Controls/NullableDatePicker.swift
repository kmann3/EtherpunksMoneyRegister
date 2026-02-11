//
//  NullableDatePicker.swift
//  EtherpunksMoneyRegister.v14
//
//  Created by Kennith Mann on 1/18/25.
//

import SwiftUI

struct NullableDatePicker: View {
    @State var name: String
    @Binding var selectedDate: Date?

    @State private var showingDatePicker = false

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    var body: some View {
        HStack {
            Text("\(name):")

            if let selectedDate = selectedDate {
                Text("\(dateFormatter.string(from: selectedDate))")

                if !self.showingDatePicker {
                    Button("Change") {
                        showingDatePicker = true
                    }


                    Button(action: {
                        self.selectedDate = nil
                    }) {
                        Text("Clear")
                            .foregroundColor(.red)
                    }
                }
            } else {
                if !self.showingDatePicker {
                    Text("(none)")
                    Button("Add Date") {
                        showingDatePicker = true
                    }
                }
            }

            if showingDatePicker {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { newValue in
                            self.selectedDate = newValue
                            self.showingDatePicker = false // Close the date picker when a date is selected
                        }
                    ),
                    displayedComponents: .date
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var date: Date? = Date()
    NullableDatePicker(name: "Pending", selectedDate: $date)
#if os(macOS)
        .frame(width: 300, height: 100)
#endif
}

#Preview {
    @Previewable @State var date: Date? = nil
    NullableDatePicker(name: "Pending", selectedDate: $date)
#if os(macOS)
        .frame(width: 300, height: 100)
#endif
}
