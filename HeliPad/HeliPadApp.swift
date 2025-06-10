//
//  HeliPadApp.swift
//  HeliPad
//
//  Created by SunnyFlops on 10/06/2025.
//

import SwiftUI

@main
struct HeliPadApp: App {
    @State private var window: NSWindow!
    
    var body: some Scene {
        WindowGroup(id: "content") {
            ContentView()
                .frame(minWidth: 960, minHeight: 640)
                .windowMinimizeBehavior(.disabled)
                .windowFullScreenBehavior(.disabled)
                .windowResizeBehavior(.disabled)
                .background {
                    if window == nil {
                        Color.clear.onReceive(NotificationCenter.default.publisher(for:
                            NSWindow.didBecomeKeyNotification)) { notification in
                            if let window = notification.object as? NSWindow {
                                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                                window.standardWindowButton(.zoomButton)?.isHidden = true
                            }
                        }
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowLevel(.floating)
        
        WindowGroup(id: "settings") {
            SettingsView()
                .frame(minWidth: 320, minHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
