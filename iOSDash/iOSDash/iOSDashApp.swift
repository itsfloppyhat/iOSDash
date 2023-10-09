//
//  iOSDashApp.swift
//  iOSDash
//
//  Created by Matthew Lucas on 8/4/23.
//

import SwiftUI

@main
struct iOSDashApp: App {
    @StateObject var user = User()
    @StateObject var manager = HealthManager()
    
    var body: some Scene {
        WindowGroup {
            StartRun()
                .environmentObject(manager)
//            AuthenticationView()
//                .environmentObject(user)
        }
    }
}
