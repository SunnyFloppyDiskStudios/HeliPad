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
      dragged != item,
      let from = fetcher.apps.firstIndex(of: dragged),
      let to   = fetcher.apps.firstIndex(of: item),
      from != to
    else { return }

    withAnimation {
      fetcher.updateOrder(from: from, to: to)
    }
  }

  func performDrop(info: DropInfo) -> Bool { true }
}

struct EmptyDropDelegate: DropDelegate {
    func performDrop(info: DropInfo) -> Bool { false }
}
