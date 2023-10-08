//
//  ContentView.swift
//  iOSDash
//
//  Created by Matthew Lucas on 8/4/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var user: User
    @State private var showingSheet = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, \(user.firstName) \(user.lastName)!")
            Button ("Show Sheet") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                SheetView()
            }
        }
        .padding()
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var user: User
    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        Text("first name: \(user.firstName) lastname: \(user.lastName) email: \(user.email) id: \(user.userId)" )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
            .environmentObject(User())
    }
}
