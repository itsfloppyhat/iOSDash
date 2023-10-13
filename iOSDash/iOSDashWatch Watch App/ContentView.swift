//
//  ContentView.swift
//  iOSDashWatch Watch App
//
//  Created by Matthew Lucas on 8/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var manager: WatchHealthManager
    @State var showRunView: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("🏃‍♂️")
                    .font(.system(size: 50))
                
                Button(action: {
                    manager.startWorkout()
                    showRunView = true
                    
                }) {
                    Text("Start Workout")
                        .bold()
                        .padding()
                        .cornerRadius(10)
                }
            }
            .padding()
            .onAppear {
                manager.requestAuthorization()
            }
            .navigationDestination(isPresented: $showRunView) {
                WatchActiveRunView()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
