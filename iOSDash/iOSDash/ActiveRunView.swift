//
//  ActiveRunView.swift
//  iOSDash
//
//  Created by Danielle Lewis on 10/8/23.
//

import SwiftUI

struct ActiveRunView: View {
    @EnvironmentObject var manager: HealthManager
    
    var body: some View {
        VStack{
            HStack{
                Text("❤️")
                    .font(.system(size: 50))
                Spacer()
            }
            HStack{
                Text("\(manager.heartRate)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))
                
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
                    .font(.system(size: 70))

                
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
            
        }
    }
    
}

#Preview {
    ActiveRunView()
}
