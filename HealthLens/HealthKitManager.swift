//
//  HealthKitManager.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/18/24.
//

import Foundation
import HealthKit
import Observation

@Observable class HealthKitManager {
    let store = HKHealthStore()
    
    let types: Set = [HKQuantityType(.stepCount), HKQuantityType(.bodyMass)]
}
