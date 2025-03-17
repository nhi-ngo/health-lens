//
//  HealthLensTests.swift
//  HealthLensTests
//
//  Created by Nhi Ngo on 3/17/25.
//

import Foundation
import Testing
@testable import HealthLens

struct HealthLensTests {

}

@Suite("Chart Math Tests")
struct ChartMathTests {
    
    var metrics: [HealthMetric] = [
        .init(date: Calendar.current.date(from: .init(year: 2025, month: 2, day: 3))!, value: 1000), // Mon
        .init(date: Calendar.current.date(from: .init(year: 2025, month: 2, day: 4))!, value: 500), // Tues
        .init(date: Calendar.current.date(from: .init(year: 2025, month: 2, day: 5))!, value: 250), // Wed
        .init(date: Calendar.current.date(from: .init(year: 2025, month: 2, day: 10))!, value: 750) // Mon
    ]
    
    @Test func averageWeekdayCount() {
        let averageWeekdayCount = ChartMath.averageWeekdayCount(for: metrics)
        #expect(averageWeekdayCount.count == 3)
        #expect(averageWeekdayCount[0].value == 875)
        #expect(averageWeekdayCount[1].value == 500)
        #expect(averageWeekdayCount[2].date.weekdayTitle == "Wednesday")
    }
}
