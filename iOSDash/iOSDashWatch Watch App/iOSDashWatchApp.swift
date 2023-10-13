//
//  iOSDashWatchApp.swift
//  iOSDashWatch Watch App
//
//  Created by Matthew Lucas on 8/4/23.
//

import SwiftUI

@main
struct iOSDashWatch_Watch_AppApp: App {
    @StateObject private var manager = WatchHealthManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}
