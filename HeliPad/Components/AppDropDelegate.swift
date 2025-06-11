//
//  AppDropDelegate.swift
//  HeliPad
//
//  Created by SunnyFlops on 11/06/2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct AppDropDelegate: DropDelegate {
  let item: AppInfo
  @ObservedObject var fetcher: AppFetcher
  @Binding var draggedItem: AppInfo?

    func dropEntered(info: DropInfo) {
        guard
            let dragged = draggedItem,
            dragged.identifier != item.identifier,
            let from = fetcher.apps.firstIndex(where: { $0.identifier == dragged.identifier }),
            let to = fetcher.apps.firstIndex(where: { $0.identifier == item.identifier }),
            from != to
        else { return }

        withAnimation {
            fetcher.updateOrder(from: from, to: to)
        }
    }
        
    func performDrop(info: DropInfo) -> Bool {
        DispatchQueue.main.async {
            withAnimation {
                draggedItem = nil
                fetcher.draggingItemID = nil
                fetcher.activeDropTargetID = nil
            }
        }
        return true
    }
}

struct EmptyDropDelegate: DropDelegate {
    func performDrop(info: DropInfo) -> Bool { false }
}
