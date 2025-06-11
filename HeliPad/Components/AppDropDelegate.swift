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
    let fetcher: AppFetcher
    let draggedItem: AppInfo

    func dropEntered(info: DropInfo) {
        guard draggedItem != item,
              let from = fetcher.apps.firstIndex(of: draggedItem),
              let to = fetcher.apps.firstIndex(of: item)
        else { return }

        if from != to {
            DispatchQueue.main.async {
                fetcher.updateOrder(from: from, to: to)
            }
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        true
    }
}

struct EmptyDropDelegate: DropDelegate {
    func performDrop(info: DropInfo) -> Bool { false }
}
