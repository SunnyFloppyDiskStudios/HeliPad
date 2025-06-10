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
    @StateObject private var fetcher = AppFetcher()
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    let columns = [GridItem(.adaptive(minimum: 80))]

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredApps) { app in
                        VStack {
                            if let icon = app.icon {
                                Image(nsImage: icon)
                                    .resizable()
                                    .frame(width: 64, height: 64)
                            }
                            Text(app.name)
                                .font(.caption)
                                .lineLimit(1)
                        }
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
        } else {
            return fetcher.apps.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
