//
//  ContentView.swift
//  HeliPad
//
//  Created by SunnyFlops on 10/06/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @StateObject private var fetcher = AppFetcher()
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    @State private var hoverSync: Bool = false
    @State private var hoverSettings: Bool = false
    
    @State private var draggedItem: AppInfo? = nil
    
    var appFocusObserver: AppFocusObserver = AppFocusObserver()
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredApps) { app in
                        AppLauncherButton(app: app, draggedItem: $draggedItem)
                            .environmentObject(fetcher)
                    }
                }
                .padding()
                .animation(.interpolatingSpring(stiffness: 200, damping: 20), value: fetcher.apps)
            }
            .padding()
        }
        .onAppear {
            appFocusObserver.dismissHandler = {
                dismissWindow(id: "content")
            }
        }
        .toolbar {
            Spacer()
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("Search In Apps...                                    ", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isSearchFocused)
                    .frame(maxWidth: .infinity)
            }
            
            Spacer()
            
            Button {
                // refresh
            } label: {
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
            }
            .onHover { hover in
                hoverSync.toggle()
            }
            .symbolEffect(.rotate, value: hoverSync)
            
            Button {
                openWindow(id: "settings")
            } label: {
                Image(systemName: "gearshape")
            }
        }
    }
    
    var filteredApps: [AppInfo] {
        if searchText.isEmpty {
            return fetcher.apps
        }
        
        let query = searchText.lowercased()
        
        return fetcher.apps.filter { app in
            let name = app.name.lowercased()
            
            if name.contains(query) {
                return true
            }
            
            let acronym = app.name.compactMap { char -> String? in
                let s = String(char)
                return s.uppercased() == s && s.rangeOfCharacter(from: .letters) != nil ? s : nil
            }.joined().lowercased()
            
            return acronym.contains(query)
        }
    }
}
