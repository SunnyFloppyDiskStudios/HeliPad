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
    @Environment(\.dismissWindow) var dismissWindow
    
    let app: AppInfo
    @Binding var draggedItem: AppInfo?
    @EnvironmentObject var fetcher: AppFetcher
    @State private var isHovering = false
    
    @Namespace private var dragNamespace

    var isBeingDragged: Bool {
        fetcher.draggingItemID == app.identifier
    }

    var isPlaceholder: Bool {
        fetcher.activeDropTargetID == app.identifier
    }

    var body: some View {
        VStack(spacing: 4) {
            if isBeingDragged || isPlaceholder {
                Color.clear
                    .frame(width: 64, height: 64)
            } else {
                Image(nsImage: app.icon ?? NSImage())
                    .resizable()
                    .frame(width: 64, height: 64)
                    .matchedGeometryEffect(id: app.identifier, in: dragNamespace)
            }

            if !isBeingDragged && !isPlaceholder {
                Text(app.name)
                    .font(.caption)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: 80)
        .scaleEffect(isHovering ? 1.15 : 1.0)
        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: isHovering)
        .onHover { isHovering = $0 }
        .onTapGesture {
            if NSEvent.modifierFlags.contains(.command) {
                NSWorkspace.shared.activateFileViewerSelecting([app.url])
            } else {
                Task {
                    NSWorkspace.shared.open(app.url)
                }
                dismissWindow(id: "content")
            }
        }
        .onDrag({
            draggedItem = app
            fetcher.draggingItemID = app.identifier
            return NSItemProvider(object: app.identifier as NSString)
        }, preview: {
            Image(nsImage: app.icon ?? NSImage())
                .resizable()
                .frame(width: 64, height: 64)
                .matchedGeometryEffect(id: app.identifier, in: dragNamespace)
        })
        .onDrop(of: [.text], delegate:
            AppDropDelegate(item: app,
                            fetcher: fetcher,
                            draggedItem: $draggedItem)
        )
    }
}
