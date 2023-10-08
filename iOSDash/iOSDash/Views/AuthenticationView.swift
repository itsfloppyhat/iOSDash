//
//  AuthenticationView.swift
//  iOSDash
//
//  Created by Matthew Lucas on 8/5/23.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var user: User
    var body: some View {
        if !user.authenticated {
            LoginView()
        } else {
            ContentView()
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(User())
    }
}
