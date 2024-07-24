//
//  ContentView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 7/19/24.
//

import SwiftUI

struct ContentView: View {
    var appSettings: AppSettings = AppSettings()

    init() {
        appSettings.LoadAppData()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        print(appVersion)
    }

    var body: some View {
        TabView {
            Text("")
                .tabItem {
                    Label("Accounts", systemImage: "house.lodge")
                }
            Text("")
                .tabItem {
                    Label("Internal", systemImage: "list.bullet.clipboard")
                }
            Text("")
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
            Text("")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

        }
        .toolbar {
            ToolbarItem {
                Menu {
                    Section("Primary Actions") {
                        Button("New Database") { newDatabase() }
                        Button("Open Database") { openDatabase() }
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
                // Update app db to show this as most recently opened item
                // open file
            }
        }
    }

    private func newDatabase() {
        // Prompt for location
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Please selecte an empty directory which will store the information. \n If the directory is not empty, a default one will be created for you falled 'EMR'"
        panel.canCreateDirectories = true

        if panel.runModal() == .OK {
            if let url = panel.url {
                //print("Selected file: \(url.path)")

                // Create new database
                // update app database to add this as a recently opened item
            }
        }
    }
}

#Preview {
    ContentView()
}
