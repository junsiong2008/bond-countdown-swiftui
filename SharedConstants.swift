//
//  SharedConstants.swift
//  BondTracker
//
//  Created by Teng Jun Siong on 12/11/2025.
//

import Foundation

struct SharedConstants {
    static let appGroupId = "group.xyz.jsdevexperiment.bondtracker"
    
    static let totalBondAmountKey = "totalBondAmount"
    static let totalServiceDaysKey = "totalServiceDays"
    static let startDateKey = "startDate"
}

extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: SharedConstants.appGroupId)!
    }
}
