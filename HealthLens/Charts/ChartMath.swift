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
    
        return weekdayChartData
    }
}
