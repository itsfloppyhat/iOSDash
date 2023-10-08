//
//  LoginView.swift
//  iOSDash
//
//  Created by Matthew Lucas on 8/4/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var user: User
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView {
            VStack {
                    SignInWithAppleButton(.continue) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                            case .success (let auth):
                                
                                switch auth.credential {
                                        case let authAppleCredential as
                                    ASAuthorizationAppleIDCredential:
                                        let email = authAppleCredential.email
                                        let firstName = authAppleCredential.fullName?.givenName
                                        let lastName = authAppleCredential.fullName?.familyName
                                        let userId = authAppleCredential.user
                                        user.login(
                                        firstName: firstName ?? "",
                                        lastName: lastName ?? "",
                                        email: email ?? "",
                                        userId: userId
                                        )
                                    default:
                                        break
                                }
                            case .failure (let error):
                                print("Authorization failed: \(error.localizedDescription)")
                        }
                    }
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black
                    )
                    .frame( height: 64)
                    .padding()
                    .cornerRadius(12)
                }
            .navigationTitle("Sign In")
            }
        }
    }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let _user = User()
        LoginView()
            .environmentObject(_user)
    }
}
