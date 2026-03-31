import WidgetKit
import SwiftUI

// MARK: - Data

struct WidgetBondData {
    let bondRemaining: Double
    let completionPercentage: Double
    let daysRemaining: Int
    let totalBondAmount: Double
    let isConfigured: Bool

    static let placeholder = WidgetBondData(
        bondRemaining: 12_500,
        completionPercentage: 37.5,
        daysRemaining: 228,
        totalBondAmount: 20_000,
        isConfigured: true
    )

    static func load() -> WidgetBondData {
        let defaults = UserDefaults(suiteName: "group.xyz.jsdevexperiment.bondtracker")
        let isConfigured = defaults?.bool(forKey: "isConfigured") ?? false
        guard isConfigured else {
            return WidgetBondData(
                bondRemaining: 0,
                completionPercentage: 0,
                daysRemaining: 0,
                totalBondAmount: 0,
                isConfigured: false
            )
        }
        return WidgetBondData(
            bondRemaining: defaults?.double(forKey: "bondRemaining") ?? 0,
            completionPercentage: defaults?.double(forKey: "completionPercentage") ?? 0,
            daysRemaining: defaults?.integer(forKey: "daysRemaining") ?? 0,
            totalBondAmount: defaults?.double(forKey: "totalBondAmount") ?? 0,
            isConfigured: true
        )
    }
}

// MARK: - Timeline

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BondEntry {
        BondEntry(date: Date(), data: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (BondEntry) -> Void) {
        completion(BondEntry(date: Date(), data: .load()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BondEntry>) -> Void) {
        let entry = BondEntry(date: Date(), data: .load())
        // Refresh daily at midnight
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: Date()).addingTimeInterval(86_400)
        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        completion(timeline)
    }
}

struct BondEntry: TimelineEntry {
    let date: Date
    let data: WidgetBondData
}

// MARK: - Views

struct BondTrackerWidgetEntryView: View {
    var entry: BondEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if entry.data.isConfigured {
            configuredView
        } else {
            unconfiguredView
        }
    }

    private var configuredView: some View {
        let data = entry.data
        let currency = currencyFormatter

        return Group {
            switch family {
            case .systemSmall:
                smallView(data: data, currency: currency)
            case .systemMedium:
                mediumView(data: data, currency: currency)
            default:
                largeView(data: data, currency: currency)
            }
        }
    }

    private func smallView(data: WidgetBondData, currency: NumberFormatter) -> some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: 6) {
                Label("Bond Tracker", systemImage: "doc.text.fill")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))

                Spacer()

                Text(currency.string(from: NSNumber(value: data.bondRemaining)) ?? "$0")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.6)

                ProgressView(value: data.completionPercentage / 100)
                    .tint(.white)

                Text("\(Int(data.completionPercentage))% complete")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(14)
        }
    }

    private func mediumView(data: WidgetBondData, currency: NumberFormatter) -> some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Bond Tracker", systemImage: "doc.text.fill")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))

                    Text(currency.string(from: NSNumber(value: data.bondRemaining)) ?? "$0")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.5)

                    Text("Bond Remaining")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("\(data.daysRemaining) days left")
                    }
                    .font(.caption)
                    .foregroundColor(.white)

                    ProgressView(value: data.completionPercentage / 100)
                        .tint(.white)
                        .frame(width: 100)

                    Text("\(Int(data.completionPercentage))% complete")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding(16)
        }
    }

    private func largeView(data: WidgetBondData, currency: NumberFormatter) -> some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: 12) {
                Label("Bond Tracker", systemImage: "doc.text.fill")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                Text(currency.string(from: NSNumber(value: data.bondRemaining)) ?? "$0")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)

                Text("Bond Remaining")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                ProgressView(value: data.completionPercentage / 100)
                    .tint(.white)

                HStack {
                    Text("\(Int(data.completionPercentage))% complete")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "calendar.badge.clock")
                        Text("\(data.daysRemaining) days left")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                }
            }
            .padding(18)
        }
    }

    private var unconfiguredView: some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.orange)
            Text("Setup Required")
                .font(.headline)
            Text("Open app to configure")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var currencyFormatter: NumberFormatter {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.locale = Locale(identifier: "en_US")
        return fmt
    }
}

// MARK: - Widget

@main
struct BondTrackerWidget: Widget {
    let kind: String = "BondTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BondTrackerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Bond Tracker")
        .description("Track your remaining bond balance and service progress.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
