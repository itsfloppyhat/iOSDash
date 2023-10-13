//
//  WatchActiveRunView.swift
//  iOSDashWatch Watch App
//
//  Created by Danielle Lewis on 10/12/23.
//

import SwiftUI

struct WatchActiveRunView: View {
    @EnvironmentObject var manager: WatchHealthManager
    
    var body: some View {
        VStack{
            HStack{
                Text("❤️")
                Spacer()
            }
            HStack{
                Text("\(manager.heartRate)")
                    .fontWeight(.regular)
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 20)
                
                Spacer()
                
            }
            
            HStack {
                Text(String(format: "%.2f", manager.distance))
                    .fontWeight(.regular)

                
                Spacer()
            }
            
            HStack {
                Text(manager.distance == 1.0 ? "Mile" : "Miles")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            Button {
                manager.endWorkout()
            } label: {
                Text("End Workout")
            }
            
        }
    }
}


#Preview {
    WatchActiveRunView()
}
