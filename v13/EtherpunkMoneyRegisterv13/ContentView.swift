//
//  ContentView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 7/19/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var container: AppStateContainer
    @State var tabState: Tab = .accounts

    var body: some View {
        TabView(selection: $tabState) {
            Text("Accounts")
                .tabItem {
                    Label("Accounts", systemImage: "house.lodge")
                }
                .tag(Tab.accounts)
            Text("Metadata")
                .tabItem {
                    Label("Metadata", systemImage: "list.bullet.clipboard")
                }
                .tag(Tab.metadata)
            Text("Reports")
                .tabItem {
                    Label("Reports", systemImage: "chart.line.uptrend.xyaxis")
                }
                .tag(Tab.reports)
            Text("Settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)

        }
        .toolbar {
            ToolbarItem {
                Menu {
                    Section("Primary Actions") {
                        Button("New Database")  { newDatabase()  }
                        Button("Open Database") { openDatabase() }
                    }
                } label: {
                    Label("Menu", systemImage: "ellipsis.circle")
                }
            }
        }
        .onAppear() {
            initApp()
        }
    }
    private func initApp() {
        
    }

    private func openDatabase() {
        #if os(macOS)
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
        #elseif os(iOS)
        print("openDatabase not implemented for iOS")
        #endif
    }

    private func newDatabase() {
        //macOS, iOS, watchOS, tvOS, visionOS, Linux, Windows
#if os(macOS)
        // Prompt for location
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Please selecte an empty directory which will store the information. \n If the directory is not empty, a default one will be created for you falled 'EMR'"
        panel.canCreateDirectories = true

        if panel.runModal() == .OK {
            if let url = panel.url {
                print("Selected file: \(url.path)")

                // Create new database
                // update app database to add this as a recently opened item
            }
        }
#elseif os(iOS)
        // show iPad and iOS
        print ("not macos?")
        #else
        print("do nothing?")
#endif

    }
}

#Preview {
    do {
        return ContentView()
            .environmentObject(AppStateContainer())
            .modelContainer(try Previewer().container)
    } catch {
        return Text("Failed: \(error.localizedDescription)")
    }
}
