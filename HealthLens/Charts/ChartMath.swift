//
//  ChartMath.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/27/24.
//

import Foundation
import Algorithms

struct ChartMath {
    
    static func averageWeekdayCount(for metric: [HealthMetric]) -> [WeekdayChartData] {
        let sortedByWeekday = metric.sorted { $0.date.weekdayInt < $1.date.weekdayInt } //date extension
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        //[HealthMetric(id: 588E1865-5B28-4EC5-B50C-717A7595A5D0, date: 2024-07-07 04:00:00 +0000, value: 7099.160007909138),(),()...]
        
        var weekdayChartData: [WeekdayChartData] = []
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgSteps = total/Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgSteps))
        }
        
        /*
         for metric in weekdayChartData {
         print("day: \(metric.date.weekdayInt), value: \(metric.value)")
         /*
          day: 1, value: 12534.519298438698
          day: 2, value: 16117.625214137275
          day: 3, value: 16728.640499057714
          day: 4, value: 12280.724952853712
          day: 5, value: 11346.83680558639
          day: 6, value: 11121.02864879459
          day: 7, value: 14084.09922076256
          */
         }
         */
        
        return weekdayChartData
    }
    
    static func averageDailyWeightDiff(for weights: [HealthMetric]) -> [WeekdayChartData] {
        var diffValues: [(date: Date, value: Double)] = []
        var weekdayChartData: [WeekdayChartData] = []
        
        for i in 1..<weights.count {
            
            let date = weights[i].date
            let diff = weights[i].value - weights[i - 1].value
            diffValues.append((date: date, value: diff))
            
        }
        
        let sortedByWeekday = diffValues.sorted { $0.date.weekdayInt < $1.date.weekdayInt }
        let weekdayArray = sortedByWeekday.chunked { $0.date.weekdayInt == $1.date.weekdayInt }
        
        for array in weekdayArray {
            guard let firstValue = array.first else { continue }
            let total = array.reduce(0) { $0 + $1.value }
            let avgWeightDiff = total/Double(array.count)
            
            weekdayChartData.append(.init(date: firstValue.date, value: avgWeightDiff))
        }
        
        /*
         for value in diffValues {
         print("\(value.date), \(value.value)")
         /*
          2024-07-05 04:00:00 +0000, 0.0
          2024-07-06 04:00:00 +0000, -0.0481406852906332
          2024-07-07 04:00:00 +0000, -1.4424259347572672
          ...
          2024-07-30 04:00:00 +0000, -0.21695666323151386
          */
         }
         
         for metric in weekdayChartData {
         print("day: \(metric.date.weekdayInt), value: \(metric.value)")
         /*
          day: 1, value: 9.699365336120664
          day: 2, value: 1.1984762920419385
          day: 3, value: 0.11684841457540784
          day: 4, value: 0.8195123748317599
          day: 5, value: -0.7783977489121506
          day: 6, value: -0.8740525048233678
          day: 7, value: -10.793439279892162
          */
         }
         */
        
        return weekdayChartData
    }
}
