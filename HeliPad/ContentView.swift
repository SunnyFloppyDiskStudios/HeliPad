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
    
    @State private var isHovering = false
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        VStack {
            
        }
        .padding()
        .toolbar {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("Search In Apps...                                           ", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isSearchFocused)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
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
}
