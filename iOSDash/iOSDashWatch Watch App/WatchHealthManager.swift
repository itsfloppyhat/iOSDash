//
//  WatchHealthManager.swift
//  iOSDashWatch Watch App
//
//  Created by Danielle Lewis on 10/12/23.
//

import Foundation
import HealthKit
import WatchKit
import WatchConnectivity

class WatchHealthManager: NSObject, ObservableObject, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error?.localizedDescription)
    }
    
    private var healthStore = HKHealthStore()
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    
    private var distanceQuery: HKAnchoredObjectQuery?
    private var heartRateQuery: HKAnchoredObjectQuery?
    private var workoutStartDate: Date?
    
    let heartRateQuantity = HKUnit(from: "count/min")
    let distanceQuantity = HKUnit.mile()
    
    @Published var inActiveWorkout: Bool = false
    
    @Published var distance: Double = 0 {
            didSet {
                sendDataToiPhone()
            }
        }
        
        @Published var heartRate: Int = 0 {
            didSet {
                sendDataToiPhone()
            }
        }
    
    override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    
    func requestAuthorization() {
        let typesToShare: Set = [HKObjectType.workoutType(),
                                 HKSeriesType.workoutRoute(),
                                 HKQuantityType.quantityType(forIdentifier: .heartRate)!]
        
        let typesToRead: Set = [HKObjectType.activitySummaryType(),
                                HKQuantityType.quantityType(forIdentifier: .heartRate)!,
                                HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle authorization result...
        }
    }
    
    func startWorkout() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running
        workoutConfiguration.locationType = .outdoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            workoutSession?.delegate = self
            workoutSession?.startActivity(with: Date())
            workoutStartDate = Date()
            startQueries()
        } catch {
            print(error.localizedDescription)
        }
        
        inActiveWorkout = true
    }
   
    
    func startQueries() {
        createDistanceQuery()
        createHeartRateQuery()
    }
    
    private func createDistanceQuery() {
        guard let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let workoutStartDate = workoutStartDate else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictStartDate)
        
        let distanceQuery = HKAnchoredObjectQuery(type: distanceType, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, newAnchor, error in
            self?.processDistanceSamples(samples: samples)
        }
        
        distanceQuery.updateHandler = { [weak self] query, samples, deletedObjects, newAnchor, error in
            self?.processDistanceSamples(samples: samples)
        }
        
        healthStore.execute(distanceQuery)
        self.distanceQuery = distanceQuery
    }
    
    private func processDistanceSamples(samples: [HKSample]?) {
        guard let distanceSamples = samples as? [HKQuantitySample] else { return }
        var totalDistance: Double = 0
        for sample in distanceSamples {
            totalDistance += sample.quantity.doubleValue(for: HKUnit.mile())
        }
        DispatchQueue.main.async {
            self.distance = totalDistance
        }
    }
    
    private func createHeartRateQuery() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate),
              let workoutStartDate = workoutStartDate else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: workoutStartDate, end: nil, options: .strictStartDate)
        
        let heartRateQuery = HKAnchoredObjectQuery(type: heartRateType, predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { [weak self] query, samples, deletedObjects, newAnchor, error in
            self?.processHeartRateSamples(samples: samples)
        }
        
        heartRateQuery.updateHandler = { [weak self] query, samples, deletedObjects, newAnchor, error in
            self?.processHeartRateSamples(samples: samples)
        }
        
        healthStore.execute(heartRateQuery)
        self.heartRateQuery = heartRateQuery
    }
    
    private func processHeartRateSamples(samples: [HKSample]?) {
        guard let heartRateSamples = samples as? [HKQuantitySample], let lastSample = heartRateSamples.last else { return }
        
        let currentBPM = lastSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
        
        DispatchQueue.main.async {
            self.heartRate = Int(currentBPM)
        }
    }

    
    func endWorkout() {
            workoutSession?.end()
            stopQueries()
            inActiveWorkout = false
        }
    
    private func stopQueries() {
        if inActiveWorkout == true {
            healthStore.stop(distanceQuery!)
            healthStore.stop(heartRateQuery!)
            distanceQuery = nil
            heartRateQuery = nil
        }
    }
    
    func sendDataToiPhone() {
        let dataToSend: [String: Any] = ["heartRate": heartRate, "distance": distance]
        WCSession.default.sendMessage(dataToSend, replyHandler: nil, errorHandler: nil)
    }

}

extension WatchHealthManager: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        // Handle state changes...
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        // Handle error...
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        // Handle workout events...
    }
}

