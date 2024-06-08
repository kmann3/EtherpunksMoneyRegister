////
////  NullableDatePicker.swift
////  EtherpunkMoneyRegister
////
////  Created by Kennith Mann on 6/7/24.
////
//
//import SwiftUI
//
//struct DateTestView: View {
//    @State private var date: Date? = Date() // Initial value
//
//       var body: some View {
//           VStack {
//               NullableDatePickerTest(name: "Pending", selectedDate: $date)
//               // Display the selected date (if any)
//           }
//           .padding()
//       }
//
//}
//let dateFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    return formatter
//}()
//
//struct NullableDatePickerTest: View {
//    @State var name: String
//    @Binding var selectedDate: Date?
//    
//    @State private var showingDatePicker = false
//    
//    var body: some View {
//        HStack {
//            Text("\(name):")
//            if let selectedDate = selectedDate {
//                Text("\(dateFormatter.string(from: selectedDate))")
//                
//                Button("Change") {
//                    showingDatePicker = true
//                }
//                
//                Button(action: {
//                    self.selectedDate = nil
//                }) {
//                    Text("Clear")
//                        .foregroundColor(.red)
//                }
//            } else {
//                Button("Add Date") {
//                    showingDatePicker = true
//                }
//            }
//            
//            if showingDatePicker {
//                DatePicker(
//                    "",
//                    selection: Binding(
//                        get: { selectedDate ?? Date() },
//                        set: { newValue in
//                            self.selectedDate = newValue
//                            self.showingDatePicker = false // Close the date picker when a date is selected
//                        }
//                    ),
//                    displayedComponents: .date
//                )
//            }
//        }
//    }
//}
//
//#Preview {
//    DateTestView()
//}
