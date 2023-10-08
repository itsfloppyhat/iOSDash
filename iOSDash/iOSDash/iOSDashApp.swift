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
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .environmentObject(user)
        }
    }
}
