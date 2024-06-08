////
////  TestView.swift
////  EtherpunkMoneyRegister
////
////  Created by Kennith Mann on 6/7/24.
////
//
//import SwiftUI
//
//struct ColorPreview: View {
//    var body: some View {
//        List {
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: false, color: Color(.sRGB, red: 25/255, green: 25/255, blue: 175/255, opacity: 0.2))
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: true, color: Color(.sRGB, red: 25/255, green: 25/255, blue: 175/255, opacity: 0.2))
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: false, color: Color(.sRGB, red: 25/255, green: 25/255, blue: 175/255, opacity: 0.2))
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: false, color: Color(.sRGB, red: 25/255, green: 25/255, blue: 175/255, opacity: 0.2))
//            
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: true, color: Color(.sRGB, red: 25/255, green: 125/255, blue: 220/255, opacity: 0.5))
//            
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: false, color: Color(.sRGB, red: 25/255, green: 25/255, blue: 175/255, opacity: 0.2))
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: false, color: Color(.sRGB, red: 25/255, green: 25/255, blue: 175/255, opacity: 0.2))
//            MultipleSelectionRowTest(tag: Tag(name: "bills"), isSelected: false, color: Color(.sRGB, red: 25/255, green: 25/255, blue: 175/255, opacity: 0.2))
//        }
//    }
//}
//
//struct MultipleSelectionRowTest: View {
//    var tag: Tag
//    var isSelected: Bool
//    //var action: () -> Void
//    var color: Color
//    
//    var body: some View {
//        HStack {
//            Text(tag.name)
//            Spacer()
//            if isSelected {
//                Image(systemName: "checkmark")
//                    .foregroundColor(.blue)
//            }
//        }
//        .background(isSelected ? color : Color.clear)
//        .contentShape(Rectangle())
//        //.onTapGesture(perform: action)
//    }
//}
//
//#Preview {
//    ColorPreview()
//}
