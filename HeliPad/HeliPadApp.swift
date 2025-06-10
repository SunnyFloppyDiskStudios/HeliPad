//
//  HeliPadApp.swift
//  HeliPad
//
//  Created by SunnyFlops on 10/06/2025.
//

import SwiftUI

@main
struct HeliPadApp: App {
    var body: some Scene {
        WindowGroup(id: "content") {
            ContentView()
                .frame(minWidth: 960, minHeight: 640)
        }
        .windowStyle(.hiddenTitleBar)
        
        WindowGroup(id: "settings") {
            SettingsView()
                .frame(minWidth: 320, minHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
