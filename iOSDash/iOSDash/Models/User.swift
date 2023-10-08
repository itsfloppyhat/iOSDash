//
//  User.swift
//  iOSDash
//
//  Created by Matthew Lucas on 8/4/23.
//

import Foundation
import RealmSwift

class User: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var userId = "" {
        didSet {
            if userId != "" {
                authenticated = true
            } else {
                authenticated = false
            }
        }
    }
    @Published var authenticated = false
    init(firstName: String = "", lastName: String = "", email: String = "", userId: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userId = userId
    }
    func login (firstName: String, lastName: String, email: String, userId: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userId = userId
        
    }
    func authenticate () {
        authenticated = !authenticated
    }
    func logout () {
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.lastName = ""
        authenticate()
    }
}
