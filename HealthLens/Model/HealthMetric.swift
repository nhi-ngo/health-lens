//
//  HealthMetric.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/20/24.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}
