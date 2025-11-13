// BondTrackerWidget.swift
import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct BondTrackerEntry: TimelineEntry {
    let date: Date
    let bondData: BondData
}

// MARK: - Timeline Provider
struct BondTrackerProvider: TimelineProvider {
    func placeholder(in context: Context) -> BondTrackerEntry {
        BondTrackerEntry(
            date: Date(),
            bondData: BondData(
                totalBondAmount: 20000,
                totalServiceDays: 1095,
                startDate: Calendar.current.date(byAdding: .day, value: -100, to: Date())!
            )
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BondTrackerEntry) -> Void) {
        let bondData = BondDataStore.loadBondData()
        let entry = BondTrackerEntry(date: Date(), bondData: bondData)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BondTrackerEntry>) -> Void) {
        let bondData = BondDataStore.loadBondData()
        let currentDate = Date()
        
        // Create entry for now
        let entry = BondTrackerEntry(date: currentDate, bondData: bondData)
        
        // Schedule next update at midnight
        let midnight = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!)
        
        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        completion(timeline)
    }
}

// MARK: - Widget View
struct BondTrackerWidgetView: View {
    var entry: BondTrackerEntry
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Image(systemName: "doc.text.fill")
                        .font(.caption)
                    Text("Bond Tracker")
                        .font(.caption2)
                        .fontWeight(.semibold)
                    Spacer()
                }
                .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                // Main content
                if entry.bondData.isConfigured {
                    // Bond Remaining - Prominent
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Remaining")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("$\(entry.bondData.bondRemaining, specifier: "%.0f")")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                    }
                    
                    // Days Remaining
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text("\(entry.bondData.daysRemaining) days left")
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white.opacity(0.9))
                    
                    // Progress Bar
                    VStack(spacing: 4) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 4)
                                
                                // Progress
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white)
                                    .frame(
                                        width: geometry.size.width * CGFloat(entry.bondData.completionPercentage / 100.0),
                                        height: 4
                                    )
                            }
                        }
                        .frame(height: 4)
                        
                        Text("\(entry.bondData.completionPercentage, specifier: "%.0f")% complete")
                            .font(.system(size: 9))
                            .foregroundColor(.white.opacity(0.8))
                    }
                } else {
                    // Not configured state
                    VStack(alignment: .leading, spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Setup Required")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Open app to configure")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(12)
        }
    }
}

// MARK: - Widget Configuration
struct BondTrackerWidget: Widget {
    let kind: String = "BondTrackerWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BondTrackerProvider()) { entry in
            BondTrackerWidgetView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .disableContentMarginsIfNeeded()
        .configurationDisplayName("Bond Tracker")
        .description("Track your remaining service bond obligation.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Widget Bundle
@main
struct BondTrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        BondTrackerWidget()
    }
}

// MARK: - Previews
#Preview(as: .systemSmall) {
    BondTrackerWidget()
} timeline: {
    BondTrackerEntry(
        date: Date(),
        bondData: BondData(
            totalBondAmount: 20000,
            totalServiceDays: 1095,
            startDate: Calendar.current.date(byAdding: .day, value: -400, to: Date())!
        )
    )
    BondTrackerEntry(
        date: Date(),
        bondData: BondData(
            totalBondAmount: 20000,
            totalServiceDays: 1095,
            startDate: Calendar.current.date(byAdding: .day, value: -800, to: Date())!
        )
    )
}

extension WidgetConfiguration {
    func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
        if #available(iOSApplicationExtension 17.0, *) {
            return self.contentMarginsDisabled()
        } else {
            return self
        }
    }
}
