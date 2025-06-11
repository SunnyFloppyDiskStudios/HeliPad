//
//  AppGatheringManager.swift
//  HeliPad
//
//  Created by SunnyFlops on 10/06/2025.
//

//  Applications Directories:
//  /Applications
//  ~/Applications
//  /System/Applications

import Foundation
import SwiftUI
import Combine
import AppKit

struct AppInfo: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: NSImage?
    let url: URL

    var identifier: String {
        url.path
    }

    static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
        lhs.identifier == rhs.identifier
    }
}

class AppFetcher: ObservableObject {
    @Published var apps: [AppInfo] = []
    private let orderKey = "HeliPadAppOrder"

    init() {
        fetchApps()
    }

    func fetchApps() {
        DispatchQueue.global(qos: .userInitiated).async {
            let paths = ["/Applications", "\(NSHomeDirectory())/Applications", "/System/Applications"]
            var scannedApps: [AppInfo] = []

            for path in paths {
                let rootURL = URL(fileURLWithPath: path, isDirectory: true)

                if let enumerator = FileManager.default.enumerator(
                    at: rootURL,
                    includingPropertiesForKeys: [.isDirectoryKey],
                    options: [.skipsHiddenFiles]
                ) {
                    for case let url as URL in enumerator {
                        guard url.pathExtension == "app" else { continue }

                        let name = Bundle(url: url)?
                            .infoDictionary?["CFBundleName"] as? String
                            ?? url.deletingPathExtension().lastPathComponent

                        let icon = NSWorkspace.shared.icon(forFile: url.path)
                        icon.size = NSSize(width: 64, height: 64)

                        scannedApps.append(AppInfo(name: name, icon: icon, url: url))
                        enumerator.skipDescendants()
                    }
                }
            }

            let savedOrder = UserDefaults.standard.stringArray(forKey: self.orderKey) ?? []
            var ordered: [AppInfo] = []

            for id in savedOrder {
                if let app = scannedApps.first(where: { $0.identifier == id }) {
                    ordered.append(app)
                }
            }

            let remaining = scannedApps.filter { app in
                !ordered.contains(app)
            }

            ordered.append(contentsOf: remaining)

            DispatchQueue.main.async {
                self.apps = ordered
                self.saveOrder(apps: ordered)
            }
        }
    }

    func saveOrder(apps: [AppInfo]) {
        let order = apps.map { $0.identifier }
        UserDefaults.standard.set(order, forKey: orderKey)
    }

    func updateOrder(from fromIndex: Int, to toIndex: Int) {
        var current = apps
        let moved = current.remove(at: fromIndex)
        current.insert(moved, at: toIndex)
        apps = current
        saveOrder(apps: current)
    }
}
