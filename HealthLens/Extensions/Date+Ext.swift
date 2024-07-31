//
//  Date+Ext.swift
//  HealthLens
//
//  Created by Nhi Ngo on 7/27/24.
//

import Foundation

extension Date {
    // The weekday units are the numbers 1 through N (where for the Gregorian calendar N=7 and 1 is Sunday).
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
    
    var weekdayTitle: String {
        self.formatted(.dateTime.weekday(.wide)) // Monday, Tuesday....
    }
}
