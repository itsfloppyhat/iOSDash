//
//
//  ContentView.swift
//  StartYourRunSwift
//
//  Created by Danielle Lewis on 7/22/23.
//

import SwiftUI

struct ContentView: View {
    @State private var goalTime: Int = 0
    @State private var distance: Double = 0.0
    @State private var effortValues = ["Easy Run", "Break A Sweat", "Race Pace"]
    @State private var effort = "Easy Run"
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 20/255, green: 3/255, blue: 3/255)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Start Your Run 🏃‍♂️💨")
                        .foregroundColor(Color(red: 172/255, green: 237/255, blue: 81/255))
                        .font(.title)
                        .fontWeight(.bold)
                    Section{
                        VStack {
                            Text("What is your goal time?")
                                .foregroundColor(Color(red: 172/255, green: 237/255, blue: 81/255))
                                .font(.headline)
                            
                            Picker("Goal Time", selection: $goalTime) {
                                ForEach(0..<61, id: \.self) { index in
                                    Text("\(index)")
                                }
                            }
                            .pickerStyle(.wheel)
                            
                            Text(goalTime == 1 ? "\(goalTime) Minute" : "\(goalTime) Minutes")
                                
                                .foregroundColor(Color(red: 172/255, green: 237/255, blue: 81/255))
                        }
                        .padding()
                       
                        
                    }
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Section{
                        VStack {
                            Text("How far would you like to run?")
                                .foregroundColor(Color(red: 172/255, green: 237/255, blue: 81/255))
                                .font(.headline)
                            
                            Picker("Goal distance", selection: $distance) {
                                ForEach(Array(stride(from: 0.0, to: 3.0, by: 0.1)), id: \.self) { index in
                                    Text(String(format: "%.1f", index))
                                }
                            }
                            .pickerStyle(.wheel)
                            
                            Text(distance == 1 ? "\(distance, specifier: "%.1f") Mile" : "\(distance, specifier: "%.1f") Miles")
                                .foregroundColor(Color(red: 172/255, green: 237/255, blue: 81/255))
                        }
                        .padding()
                    }
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    Section {
                        VStack {
                            Text("At what pace?")
                                .foregroundColor(Color(red: 172/255, green: 237/255, blue: 81/255))
                                .font(.headline)
                            
                            Picker("Effort", selection: $effort) {
                                ForEach(effortValues, id: \.self) { value in
                                    Text(value)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                        .padding()
                    }
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button(action: {
                        // action
                    }) {
                        Text("GO")
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 40)
                            .background(Color(red: 172/255, green: 237/255, blue: 81/255))
                            .cornerRadius(40)
                    }
                    Spacer()
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
