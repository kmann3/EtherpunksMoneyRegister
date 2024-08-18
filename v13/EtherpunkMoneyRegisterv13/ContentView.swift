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
                        Button {
                            debugPrint("Delete item")
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .onTapGesture {
                        loadedSqliteDbPath = row.path
                    }
                }
            } else {
                Button {
                    debugPrint("New Database")
                } label: {
                    Text("New Database")
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
}

#Preview {
    do {
        return ContentView()
            .environmentObject(LocalAppStateContainer())
            //.modelContainer(try Previewer().container)
    } catch {
        debugPrint("Failed: \(error.localizedDescription)")
        return Text("Failed: \(error.localizedDescription)")
    }
}
