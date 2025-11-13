// TrackingView.swift
import SwiftUI

struct TrackingView: View {
    @EnvironmentObject var dataStore: BondDataStore
    @State private var showSetup = false
    
    var bondData: BondData {
        dataStore.bondData
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Card - Bond Remaining
                    VStack(spacing: 8) {
                        Text("Bond Remaining")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("$\(bondData.bondRemaining, specifier: "%.2f")")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.1))
                    )
                    .padding(.horizontal)
                    
                    // Progress Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Progress")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(bondData.completionPercentage, specifier: "%.1f")%")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        
                        ProgressView(value: bondData.completionPercentage, total: 100)
                            .tint(.blue)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
    Color.gray.opacity(0.2)
)
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                    )
                    .padding(.horizontal)
                    
                    // Stats Grid
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Days Served",
                                value: "\(bondData.daysServed)",
                                icon: "calendar.badge.checkmark",
                                color: .green
                            )
                            
                            StatCard(
                                title: "Days Remaining",
                                value: "\(bondData.daysRemaining)",
                                icon: "calendar.badge.clock",
                                color: .orange
                            )
                        }
                        
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Daily Cost",
                                value: "$\(bondData.dailyBondCost, default: "%.2f")",
                                icon: "dollarsign.circle",
                                color: .purple
                            )
                            
                            StatCard(
                                title: "Total Days",
                                value: "\(bondData.totalServiceDays)",
                                icon: "calendar",
                                color: .blue
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Bond Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Bond Details")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        DetailRow(label: "Total Bond Amount", value: "$\(bondData.totalBondAmount, default: "%.2f")")
                        DetailRow(label: "Start Date", value: bondData.startDate.formatted(date: .long, time: .omitted))
                        
                        if bondData.daysRemaining > 0 {
                            let endDate = Calendar.current.date(byAdding: .day, value: bondData.daysRemaining, to: Date()) ?? Date()
                            DetailRow(label: "Estimated End Date", value: endDate.formatted(date: .long, time: .omitted))
                        } else {
                            DetailRow(label: "Status", value: "✅ Service Complete!")
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
    Color.gray.opacity(0.2)

)
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                    )
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
#if os(macOS)
            .background(Color(.underPageBackgroundColor))
#else
            .background(Color(.systemGroupedBackground))
#endif
            .navigationTitle("Bond Tracker")
            .toolbar {
                Button(action: { showSetup = true }) {
                    Image(systemName: "gearshape.fill")
                }
            }
            .sheet(isPresented: $showSetup) {
                SetupView()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
    Color.gray.opacity(0.2)
)
                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        )
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TrackingView()
        .environmentObject(BondDataStore())
}

