//
//  ChartDataTypes.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/27/24.
//

import Foundation

struct WeekdayChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let value: Double
}
