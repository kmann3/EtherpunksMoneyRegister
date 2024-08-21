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
        VStack {
            if loadedSqliteDbPath == nil {
                HStack {
                    Spacer()
                    Button() {
                        newDatabase()
                    } label: {
                        Label("New", systemImage: "doc")
                    }
                    .padding()

                    Spacer()

                    Button() {
                        openDatabase()
                    } label: {
                        Label("Open", systemImage: "square.and.arrow.up")
                    }
                    .padding()

                    Spacer()
                }

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
                    .onAppear() {
                        debugPrint("Row: \(row.path)")
                    }
                    .onTapGesture {
                        loadedSqliteDbPath = row.path
                    }
                }
            } else {
                MainView()
            }
        }
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
            debugPrint("loading...")
            debugPrint("\(recentFileEntries.count)")
        }
    }
    private func initApp() {
        appContainer.loadAppData()
        if appContainer.loadedSqliteDbPath != nil {
            return
        }

        if appContainer.recentFileEntries.count == 0 {
            newDatabase()
        } else {
            recentFileEntries = appContainer.recentFileEntries
        }
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

#Preview("Empty AppDb", traits: .fixedLayout(width: 750, height: 500)) {
    return ContentView()
        .environmentObject(LocalAppStateContainer())
    //.modelContainer(try Previewer().container)
}

#Preview("Filled AppDb - no Sql", traits: .fixedLayout(width: 750, height: 500)) {
    var container = LocalAppStateContainer()

    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    if let pathComponent = url.appendingPathComponent("emr_appdata.sqlite3.emr") {
        container.appDbPath = pathComponent.path()
    } else {
        container.appDbPath = ""
        debugPrint("ERROR LOADING APP DB")
    }

    return ContentView()
        .environmentObject(container)
}

#Preview("Filled AppDb - w/ Sql", traits: .fixedLayout(width: 750, height: 500)) {
    var container = LocalAppStateContainer()


    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    if let pathComponent = url.appendingPathComponent("emr_appdata.sqlite3.emr") {
        container.appDbPath = pathComponent.path()
    } else {
        container.appDbPath = ""
        debugPrint("ERROR LOADING APP DB")
    }

    container.loadedSqliteDbPath = "/Users/kennithmann/Downloads/money_sqlite.mmr"

    return ContentView()
        .environmentObject(container)
}
