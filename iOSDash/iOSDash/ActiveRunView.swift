//
//  ActiveRunView.swift
//  iOSDash
//
//  Created by Danielle Lewis on 10/8/23.
//

import SwiftUI

struct ActiveRunView: View {
    @EnvironmentObject var healthManager: HealthManager

       var body: some View {
           VStack {
               Text("Heart Rate: \(healthManager.heartRate, specifier: "%.0f") BPM")
                   .font(.largeTitle)
                   .padding()
               
               Text("Distance: \(healthManager.distance, specifier: "%.2f") Meters")
                   .font(.largeTitle)
                   .padding()
           }
       }
}

#Preview {
    ActiveRunView()
}
