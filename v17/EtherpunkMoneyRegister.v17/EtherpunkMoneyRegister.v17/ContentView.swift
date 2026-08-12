//
//  ContentView.swift
//  EtherpunkMoneyRegister.v17
//
//  Created by Kenny Mann on 7/12/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.createdOnUTC, order: .reverse) private var items: [Account]
    let foo: DataSource = DataSource.init()

    var body: some View {
        NavigationViewWrapper {
            List {
                Button("Add") {
                    //addItem()
                    //var foo: DataSource = DataSource.init()
                    //debugPrint(foo.previewer.cvsTransaction.name)
                }
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.name)")
                    } label: {
                        Text(item.createdOnUTC, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Account()
            newItem.name = "Acc.\(newItem.createdOnUTC)"
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

fileprivate struct NavigationViewWrapper<Content: View>: View {
    let content: () -> Content

    var body: some View {
#if os(macOS)
        NavigationSplitView {
            content()
        } detail: {
            Text("Select an item")
        }
#else
        content()
#endif
    }
}

#Preview {
    do {
        let mc = try ModelContainer(for: Account.self, configurations: ModelConfiguration(schema: Schema(Account.self), isStoredInMemoryOnly: false))
        return ContentView().modelContainer(mc)
    } catch {
        fatalError()
    }
}

//#Preview("CalculateLoan - Sample Data") {
//    let vm = CalculateLoanViewModel()
//    vm.carPrice = 47079
//    vm.loanTerm = 72
//    vm.loanInterestRate = 4.75
//    vm.incentives = 1000
//    vm.addons = 2300
//    vm.downPayment = 0
//    vm.tradeInValue = 39000
//    vm.tradeInOwed = 17479
//    vm.tax = 8.25
//    vm.fees = 600
//
//    return CalculateLoanView(calculateLoanViewModel: vm, isAdvanced: true)
//}
