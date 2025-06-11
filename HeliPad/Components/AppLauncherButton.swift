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
    @State private var isHovering = false
    @Binding var draggedItem: AppInfo?
    @EnvironmentObject var fetcher: AppFetcher

    var body: some View {
        Button {
            if NSEvent.modifierFlags.contains(.command) {
                NSWorkspace.shared.activateFileViewerSelecting([app.url])
            } else {
                NSWorkspace.shared.open(app.url)
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
            .scaleEffect(isHovering ? 1.15 : 1.0)
            .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onDrag {
            self.draggedItem = app
            return NSItemProvider(object: app.identifier as NSString)
        }
        .onDrop(of: [.text],
                delegate: AppDropDelegate(item: app,
                                          fetcher: fetcher,
                                          draggedItem: $draggedItem))
    }
}
