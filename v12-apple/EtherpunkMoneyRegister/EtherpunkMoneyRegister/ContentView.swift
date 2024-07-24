//
//  ContentView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftUI

struct ContentView: View {
    init() {
        // if there are no accounts - default to prompting the user to make one.
    }
    var body: some View {
        TabView {
            AccountListView()
                .tabItem {
                    Label("Accounts", systemImage: "house.lodge")
                }
            InternalView()
                .tabItem {
                    Label("Internal", systemImage: "list.bullet.clipboard")
                }
            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

        }
        .toolbar {
            ToolbarItem {
                Menu {
                    Section("Primary Actions") {
                        Button("New Database") {  }
                        Button("Open Database") {  }
                    }

                    Divider()

                    Button(role: .destructive) {
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
    }

    private func openDatabase() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false

        if panel.runModal() == .OK {
            if let url = panel.url {
                print("Selected file: \(url.path)")
                // Handle the selected file URL
            }
        }
    }

    private func newDatabase() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Please selecte an empty directory which will store the information. \n If the directory is not empty, a default one will be created for you falled 'EMR'"
        panel.canCreateDirectories = true

        if panel.runModal() == .OK {
            if let url = panel.url {
                print("Selected file: \(url.path)")
                // Handle the selected file URL
            }
        }

    }
}

#Preview {
    do {
        let previewer = try Previewer()

        return ContentView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
