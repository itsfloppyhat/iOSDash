//
//  WorkoutManager.swift
//  iOSDashWatch Watch App
//
//  Created by Danielle Lewis on 10/8/23.
//

import Foundation
import HealthKit
import WatchConnectivity

class WorkoutManager: NSObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
           switch toState {
           case .notStarted:
               print("Workout session not started.")
           case .running:
               print("Workout session started.")
           case .ended:
               print("Workout session ended.")
               workoutSession.end()
               workoutBuilder?.endCollection(withEnd: date, completion: { (success, error) in
                   // Handle error or success
               })
           default:
               print("Unknown workout session state: \(toState)")
           }
       }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard let command = message["command"] as? String, command == "startWorkout" else { return }
        
        // Code to start the workout
        startWorkout()
    }
    
       func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
           print("Workout session failed with error: \(error)")
           // Handle error, e.g., show an alert to the user
       }
       
       func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
           print("Workout builder did collect event.")
           // Handle collected event, e.g., update your UI or process the event
       }
    
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?
    let healthStore = HKHealthStore()
    
    func startWorkout() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .outdoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)
            
            workoutSession?.delegate = self
            workoutBuilder?.delegate = self
            
            workoutSession?.startActivity(with: nil)
            workoutBuilder?.beginCollection(withStart: Date(), completion: { (success, error) in
                // Handle error
            })
        } catch {
            // Handle error
        }
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }

        if let heartRateStatistics = workoutBuilder.statistics(for: heartRateType),
           let distanceStatistics = workoutBuilder.statistics(for: distanceType) {
            let heartRate = heartRateStatistics.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            let distance = distanceStatistics.sumQuantity()?.doubleValue(for: HKUnit.mile()) ?? 0
            
            let session = WCSession.default
            if session.isReachable {
                let message = ["heartRate": heartRate, "distance": distance]
                session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            }
        }
    }

}
