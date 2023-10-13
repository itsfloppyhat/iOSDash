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

class HealthManager: NSObject, ObservableObject {
    
    
    
    private var healthStore = HKHealthStore()
    let heartRateQuantity = HKUnit(from: "count/min")
    let distanceQuantity = HKUnit.mile()
    
    private var distanceQuery: HKAnchoredObjectQuery?
    private var heartRateQuery: HKAnchoredObjectQuery?
    private var workoutStartDate: Date?
    
    @Published var heartRate = 0
    @Published var distance = 0.0
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    
//    func start() {
//        func startQueries() {
//            createDistanceQuery()
//            createHeartRateQuery()
//        }
//    }
//    
//    func autorizeHealthKit() {
//        
//        let healthKitTypes: Set = [
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
//            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
//        ]
//        
//        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in }
//    }
//    
//    private func createDistanceQuery() {
//        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
//              let workoutStartDate = workoutStartDate else { return }
//        
//        let predicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictStartDate)
//        
//        let distanceQuery = HKAnchoredObjectQuery(type: distanceType, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, newAnchor, error in
//            self?.processDistanceSamples(samples: samples)
//        }
//        
//        distanceQuery.updateHandler = { [weak self] query, samples, deletedObjects, newAnchor, error in
//            self?.processDistanceSamples(samples: samples)
//        }
//        
//        healthStore.execute(distanceQuery)
//        self.distanceQuery = distanceQuery
//    }
//    
//    private func processDistanceSamples(samples: [HKSample]?) {
//        guard let distanceSamples = samples as? [HKQuantitySample] else { return }
//        var totalDistance: Double = 0
//        for sample in distanceSamples {
//            totalDistance += sample.quantity.doubleValue(for: HKUnit.meter())
//        }
//        DispatchQueue.main.async {
//            self.distance = totalDistance
//        }
//    }
//    
//    private func createHeartRateQuery() {
//        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
//              let workoutStartDate = workoutStartDate else { return }
//        
//        let predicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictStartDate)
//        
//        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, newAnchor, error in
//            self?.processHeartRateSamples(samples: samples)
//        }
//        
//        heartRateQuery.updateHandler = { [weak self] query, samples, deletedObjects, newAnchor, error in
//            self?.processHeartRateSamples(samples: samples)
//        }
//        
//        healthStore.execute(heartRateQuery)
//        self.heartRateQuery = heartRateQuery
//    }
//    
//    private func processHeartRateSamples(samples: [HKSample]?) {
//        guard let heartRateSamples = samples as? [HKQuantitySample], let lastSample = heartRateSamples.last else { return }
//        
//        let currentBPM = lastSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
//        
//        DispatchQueue.main.async {
//            self.heartRate = Int(currentBPM)
//        }
//    }
//    
//    func startQueries() {
//        createDistanceQuery()
//        createHeartRateQuery()
//    }
//    
//    private func stopQueries() {
//        healthStore.stop(distanceQuery!)
//        healthStore.stop(heartRateQuery!)
//        distanceQuery = nil
//        heartRateQuery = nil
//    }
}

extension HealthManager: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        // handle inactive
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // handle deactivation
    }
    

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error?.localizedDescription)
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let receivedHeartRate = message["heartRate"] as? Int {
                self.heartRate = receivedHeartRate
            }
            
            if let receivedDistance = message["distance"] as? Double {
                self.distance = receivedDistance
            }
        }
    }
}



