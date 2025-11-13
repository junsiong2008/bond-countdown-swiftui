//
//  File.swift
//  BondTracker
//
//  Created by Teng Jun Siong on 12/11/2025.
//
import Foundation
import Combine
#if canImport(WidgetKit)
import WidgetKit
#endif

struct BondData {
    var totalBondAmount: Double
    var totalServiceDays: Int
    var startDate: Date
    
    // Computed properties for tracking
    var daysServed: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: Date())
        return max(0, components.day ?? 0)
    }
    
    var daysRemaining: Int {
        max(0, totalServiceDays - daysServed)
    }
    
    var completionPercentage: Double {
        guard totalServiceDays > 0 else { return 0 }
        let percentage = Double(daysServed) / Double(totalServiceDays) * 100.0
        return min(100.0, max(0.0, percentage))
    }
    
    var dailyBondCost: Double {
        guard totalServiceDays > 0 else { return 0 }
        return totalBondAmount / Double(totalServiceDays)
    }
    
    var bondRemaining: Double {
        guard totalServiceDays > 0 else { return totalBondAmount }
        let remaining = totalBondAmount * (Double(daysRemaining) / Double(totalServiceDays))
        return max(0, remaining)
    }
    
    var isConfigured: Bool {
        totalBondAmount > 0 && totalServiceDays > 0
    }
}

class BondDataStore: ObservableObject {
    @Published var bondData: BondData
    
    private let defaults = UserDefaults.shared
    
    init() {
        // Load saved data or use defaults
        let amount = defaults.double(forKey: SharedConstants.totalBondAmountKey)
        let days = defaults.integer(forKey: SharedConstants.totalServiceDaysKey)
        let date = defaults.object(forKey: SharedConstants.startDateKey) as? Date ?? Date()
        
        self.bondData = BondData(
            totalBondAmount: amount,
            totalServiceDays: days,
            startDate: date
        )
    }
    
    func saveBondData() {
        defaults.set(bondData.totalBondAmount, forKey: SharedConstants.totalBondAmountKey)
        defaults.set(bondData.totalServiceDays, forKey: SharedConstants.totalServiceDaysKey)
        defaults.set(bondData.startDate, forKey: SharedConstants.startDateKey)
        defaults.synchronize()
        
        // Reload widget timelines when data changes
        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }
    
    static func loadBondData() -> BondData {
        let defaults = UserDefaults.shared
        let amount = defaults.double(forKey: SharedConstants.totalBondAmountKey)
        let days = defaults.integer(forKey: SharedConstants.totalServiceDaysKey)
        let date = defaults.object(forKey: SharedConstants.startDateKey) as? Date ?? Date()
        
        return BondData(
            totalBondAmount: amount,
            totalServiceDays: days,
            startDate: date
        )
    }
}

