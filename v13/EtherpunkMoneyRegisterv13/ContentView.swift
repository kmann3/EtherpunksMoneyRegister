//
//  ContentView.swift
//  EtherpunkMoneyRegisterv13
//
//  Created by Kennith Mann on 7/19/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var appContainer: LocalAppStateContainer
    @State var tabSelection: Tab = .accounts

    // We do these two variables like this because you can't observe an environmentobject, so we cheat
    @State var recentFileEntries: [RecentFileEntry] = []
    @State var loadedSqliteDbPath: String? = nil

    var body: some View {
        if loadedSqliteDbPath == nil {
            if !recentFileEntries.isEmpty {
                List(recentFileEntries) { row in
                    HStack {
                        Text(row.path)
                        Text(row.createdOnLocalString)
                        Spacer()
                        Button(role: .destructive) {
                            removeEntry(entry: row)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .onTapGesture {
                        loadedSqliteDbPath = row.path
                    }
                }
            } else {
                VStack {
                    Button {
                        newDatabase()
                    } label: {
                        Text("New Database")
                    }
                    
                    Button {
                        openDatabase()
                    } label: {
                        Text("Open Database")
                    }
                }
                .onAppear() {
                    initApp()
                    recentFileEntries = appContainer.recentFileEntries
                    loadedSqliteDbPath = appContainer.loadedSqliteDbPath
                }
            }

        } else {
            MainView()
                .toolbar {
                    ToolbarItem (placement: .primaryAction) {
                        Menu {
                            Section("Primary Actions") {
                                Button("New Database") { newDatabase() }
                                Button("Open Database") { openDatabase() }
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
                .onAppear() {
                    initApp()
                }
        }
    }
    private func initApp() {
        appContainer.loadAppData()
        if appContainer.loadedSqliteDbPath != nil {
            return
        }

        // Otherwise it's nil and we need to prompt the user for a new database
        //newDatabase()
    }

    private func removeEntry(entry: RecentFileEntry) {
        RecentFileEntry.deleteFileEntry(appDbPath: appContainer.appDbPath!, id: entry.id)
        recentFileEntries.removeAll { $0.id == entry.id }
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
                    debugPrint("Selected file: \(url.path)")
                    appContainer.loadedSqliteDbPath = url.path
                    DbController.createDatabase(appContainer: appContainer)
                    loadedSqliteDbPath = url.path
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
                        debugPrint("Selected file: \(url.path)")
                        appContainer.loadedSqliteDbPath = url.path
                        RecentFileEntry.insertFilePath(appContainer: appContainer)
                        appContainer.recentFileEntries = RecentFileEntry.getFileEntries(appDbPath: appContainer.appDbPath!)
                        recentFileEntries = appContainer.recentFileEntries
                        loadedSqliteDbPath = url.path
                    }
                }
            #elseif os(iOS)
                print("openDatabase not implemented for iOS")
            #endif
        }
}

#Preview {
    return ContentView()
        .environmentObject(LocalAppStateContainer())
        //.modelContainer(try Previewer().container)
}
