//
//  HealthKitController.swift
//  iOSDash
//
//  Created by Danielle Lewis on 10/8/23.
//
import Foundation
import HealthKit
import WatchConnectivity
import SwiftUI

class HealthManager: NSObject, WCSessionDelegate, ObservableObject {
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Notify the user that the session has become inactive,
        // perhaps suggesting they check the connection between their phone and watch.
        print("The WCSession has become inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Notify the user that the session has been deactivated.
        print("The WCSession has been deactivated.")

        // Attempt to reactivate the session.
        session.activate()
    }

    
    @Published var heartRate: Double = 0
    @Published var distance: Double = 0
    
    private let healthStore = HKHealthStore()
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        requestAuthorization()
    }
    
    func requestAuthorization() {
            // The types of data this app will write to HealthKit
            let typesToShare: Set = [HKObjectType.workoutType()]
            
            // The types of data this app will read from HealthKit
            let typesToRead: Set = [
                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
            ]
            
            // Request authorization
            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
                if let error = error {
                    // Handle error
                    print("Error requesting HealthKit authorization: \(error)")
                } else if !success {
                    // Handle case where user did not authorize access
                    print("User did not authorize access to HealthKit data")
                } else {
                    print("HealthKit authorization successful")
                }
            }
        }
    
    func startWorkout() {
            let session = WCSession.default
            if session.isReachable {
                let message = ["command": "startWorkout"]
                session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                    print("Failed to send message: \(error)")
                })
            }
        }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation completion if needed
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let heartRate = message["heartRate"] as? Double {
                self.heartRate = heartRate
            }
            if let distance = message["distance"] as? Double {
                self.distance = distance
            }
        }
    }
}
