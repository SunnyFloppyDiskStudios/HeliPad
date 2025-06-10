//
//  AppFocusObserver.swift
//  HeliPad
//
//  Created by SunnyFlops on 11/06/2025.
//

import AppKit
import SwiftUI
import Combine

class AppFocusObserver: ObservableObject {
    @Environment(\.dismissWindow) var dismissWindow
    var dismissHandler: (() -> Void)?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidResignActive),
            name: NSApplication.didResignActiveNotification,
            object: nil
        )
    }

    @objc private func appDidResignActive() {
        dismissHandler?()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

