//
//  AppGatheringManager.swift
//  HeliPad
//
//  Created by SunnyFlops on 10/06/2025.
//

import Foundation
import SwiftUI
import Combine
import AppKit

struct AppInfo: Identifiable {
    let id = UUID()
    let name: String
    let icon: NSImage?
    let url: URL
}

class AppFetcher: ObservableObject {
    @Published var apps: [AppInfo] = []

    init() {
        fetchApps()
    }

    func fetchApps() {
        let paths = ["/Applications", "\(NSHomeDirectory())/Applications"]
        var allApps: [AppInfo] = []

        for path in paths {
            let rootURL = URL(fileURLWithPath: path, isDirectory: true)

            if let enumerator = FileManager.default.enumerator(at: rootURL, includingPropertiesForKeys: [.isDirectoryKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
                for case let url as URL in enumerator {
                    guard url.pathExtension == "app" else { continue }

                    if let bundle = Bundle(url: url),
                       let name = bundle.infoDictionary?["CFBundleName"] as? String ?? bundle.infoDictionary?["CFBundleDisplayName"] as? String {

                        let icon = NSWorkspace.shared.icon(forFile: url.path)
                        icon.size = NSSize(width: 64, height: 64)

                        allApps.append(AppInfo(name: name, icon: icon, url: url))
                    }

                    enumerator.skipDescendants() // prevent descending into .app packages
                }
            }
        }

        DispatchQueue.main.async {
            self.apps = allApps.sorted { $0.name.lowercased() < $1.name.lowercased() }
        }
    }
}
