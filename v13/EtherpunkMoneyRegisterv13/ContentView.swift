//
//  ContentView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 7/19/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var container: LocalAppStateContainer
    @State var tabSelection: Tab = .accounts

    var body: some View {
        TabView(selection: $tabSelection) {
            AccountListView(tabSelection: $tabSelection)
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
                        //Button("Open Database") { openDatabase() }
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
        container.loadAppData()
    }

    private func newDatabase() {
        //macOS, iOS, watchOS, tvOS, visionOS, Linux, Windows
#if os(macOS)
        // Prompt for location
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.allowedContentTypes = [UTType.database]
        panel.nameFieldStringValue = "money_sqlite.mmr"
        panel.isExtensionHidden = false
        if panel.runModal() == .OK {
            if let url = panel.url {
                print("Selected file: \(url.path)")
                container.loadedSqliteDbPath = url.path
                DbController.createDatabase(appContainer: container)
                // update app database to add this as a recently opened item
            }
        }
#elseif os(iOS)
        // show iPad and iOS
        print ("iOS not implemented")
        #else
        print("Unknown OS detected")
#endif

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
}

#Preview {
    do {
        return ContentView()
            .environmentObject(LocalAppStateContainer())
            //.modelContainer(try Previewer().container)
    } catch {
        print("Failed: \(error.localizedDescription)")
        return Text("Failed: \(error.localizedDescription)")
    }
}
