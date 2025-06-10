//
//  ContentView.swift
//  HeliPad
//
//  Created by SunnyFlops on 10/06/2025.
//

//  Applications Directories:
//  /Applications
//  ~/Applications

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    @StateObject private var fetcher = AppFetcher()
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredApps) { app in
                        AppLauncherButton(app: app)
                    }
                }
            }
            .padding()
        }
        .toolbar {
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

struct AppLauncherButton: View {
    let app: AppInfo
    @State private var isHovering = false
    
    @Environment(\.dismissWindow) var dismissWindow

    var body: some View {
        Button {
            if NSEvent.modifierFlags.contains(.command) {
                NSWorkspace.shared.activateFileViewerSelecting([app.url])
            } else {
                Task {
                    NSWorkspace.shared.open(app.url)
                }
                dismissWindow(id: "content")
            }
        } label: {
            VStack {
                if let icon = app.icon {
                    Image(nsImage: icon)
                        .resizable()
                        .frame(width: 64, height: 64)
                }
                Text(app.name)
                    .font(.caption)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)
            .scaleEffect(isHovering ? 1.3 : 1.0)
            .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
