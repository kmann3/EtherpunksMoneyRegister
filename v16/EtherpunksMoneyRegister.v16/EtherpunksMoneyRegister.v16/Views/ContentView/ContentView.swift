//
//  ContentView.swift
//  EtherpunksMoneyRegister.v16
//
//  Created by Kenny Mann on 2/11/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel = ViewModel()
    @State private var nav = NavigationState()
    
    var body: some View {
        NavigationSplitView {
            SidebarView(
                selection: Binding(
                    get: { self.nav.primary },
                    set: { self.nav.primary = $0 }
                ),
                accounts: self.viewModel.accounts,
                onAction: { action in self.changeRoute(action) }
            )
            .navigationSplitViewColumnWidth(200)
        } content: {
            if let route = nav.primary {
                contentViewBuilder(for: route)
            }
        } detail: {
            if let route = nav.secondary {
                detailViewBuilder(for: route)
            }
        }
    }
    
    
    func changeRoute(_ route: PathStore.Route) {
#if DEBUG
        print("changeRoute: \(route)")
#endif
        
        switch route {
            
        case .account_Create:

        break
            
        default:
            break
        }
        
        self.nav.apply(route)
    }
}

#Preview {
    ContentView()
#if os(macOS)
        .frame(minWidth: 1200, minHeight: 750)
#endif
}

extension ContentView {
    @ViewBuilder
    private func contentView() -> some View {
        Text("S")
    }
}
