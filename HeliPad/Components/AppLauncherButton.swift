//
//  AppLauncherButton.swift
//  HeliPad
//
//  Created by SunnyFlops on 11/06/2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct AppLauncherButton: View {
    let app: AppInfo
    @Binding var draggedItem: AppInfo?
    @EnvironmentObject var fetcher: AppFetcher
    @State private var isHovering = false

    var body: some View {
        VStack(spacing: 4) {
            Image(nsImage: app.icon ?? NSImage())
                .resizable()
                .frame(width: 64, height: 64)
            Text(app.name)
                .font(.caption)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
        .scaleEffect(isHovering ? 1.15 : 1.0)
        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: isHovering)
        .onHover { isHovering = $0 }
        .onTapGesture {
            if NSEvent.modifierFlags.contains(.command) {
                NSWorkspace.shared.activateFileViewerSelecting([app.url])
            } else {
                NSWorkspace.shared.open(app.url)
            }
        }
        .onDrag({
            draggedItem = app
            return NSItemProvider(object: app.identifier as NSString)
        }, preview: {
            Image(nsImage: app.icon ?? NSImage())
                .resizable()
                .frame(width: 64, height: 64)
                .shadow(radius: 4)
        })
        .onDrop(of: [.text], delegate:
            AppDropDelegate(item: app,
                            fetcher: fetcher,
                            draggedItem: $draggedItem)
        )
    }
}

