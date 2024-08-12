//
//  ContentView.swift
//  EtherpunkMoneyRegister
//
//  Created by Kennith Mann on 5/17/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var container: AppStateContainer
    @EnvironmentObject var tabState: TabViewState

    init() {
        // if there are no accounts - default to prompting the user to make one.
    }
    var body: some View {
        TabView(selection: $tabState.selectedTab) {
            AccountListView()
                .tabItem { Label("Accounts", systemImage: "house.lodge") }
                .tag(Tab.accounts)
            MetadataView()
                .tabItem {
                    Label("Metadata", systemImage: "list.bullet.clipboard")
                }
                .tag(Tab.metadata)
            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.reports)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)

        }
        .toolbar {
            ToolbarItem (placement: .primaryAction) {
                Menu {
                    Section("Primary Actions") {
                        Button("New Database") { print("New database") }
                        Button("Open Database") { print("Open database") }
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
        .onAppear {
            // We need to query the database and pre-load settings
            initApp()
            //container.begin()
            //container.loadedSqliteDbPath = "FOO"
        }
    }

    private func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    private func initApp() {
        container.loadedSqliteDbPath = ""
        // get the app's db location and pull settings
        let fileManager = FileManager.default

        // Get the app's Application Support directory
        if let appSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            // Create a subdirectory for your app within Application Support
            let appDataDirectory = appSupportDirectory.appendingPathComponent(Bundle.main.bundleIdentifier ?? "com.etherpunk.EtherpunkMoneyRegister", isDirectory: true)

            if(directoryExists(at: appDataDirectory)) {
                print("exists")
                // If it does exist - let's see if the settings database also exists
            } else {
                print("not exists")
                // If it doesn't exist we need to create it and also create a settings database
            }
//            // Create the directory if it doesn't exist
//            do {
//                print("Creating directory")
//                    //try fileManager.createDirectory(at: appDataDirectory, withIntermediateDirectories: true, attributes: nil)
//            } catch {
//                print("Error creating app data directory: \(error)")
//            }
            // Desktop directory
            //file:///Users/kennithmann/Library/Containers/com.etherpunk.EtherpunkMoneyRegister/Data/Library/Application%20Support/com.etherpunk.EtherpunkMoneyRegister/

            // Mobile directory
            //file:///Users/kennithmann/Library/Developer/CoreSimulator/Devices/ED7C24D3-BFEB-4DD8-A002-2EAB3ABDA45C/data/Containers/Data/Application/79354604-E348-44FF-8E42-873CAC631D25/Library/Application%20Support/com.etherpunk.EtherpunkMoneyRegister/
            print(appDataDirectory)
        }
    }

    private func openDatabase() {
//        let panel = NSOpenPanel()
//        panel.canChooseFiles = true
//        panel.canChooseDirectories = false
//        panel.allowsMultipleSelection = false
//
//        if panel.runModal() == .OK {
//            if let url = panel.url {
//                print("Selected file: \(url.path)")
//                // Handle the selected file URL
//            }
//        }
    }

    private func newDatabase() {
//        let panel = NSOpenPanel()
//        panel.canChooseFiles = false
//        panel.canChooseDirectories = true
//        panel.allowsMultipleSelection = false
//        panel.message = "Please selecte an empty directory which will store the information. \n If the directory is not empty, a default one will be created for you falled 'EMR'"
//        panel.canCreateDirectories = true
//
//        if panel.runModal() == .OK {
//            if let url = panel.url {
//                print("Selected file: \(url.path)")
//                // Handle the selected file URL
//            }
//        }

    }
}

#Preview {
    do {
        let previewer = try Previewer()
        let tabState = TabViewState()
        let appState = AppStateContainer()

        return ContentView()
            .environmentObject(tabState)
            .environmentObject(appState)
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
