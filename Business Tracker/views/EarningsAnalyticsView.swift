import SwiftUI
import Charts

struct EarningsAnalyticsView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Earnings Analytics")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Earnings by Payment Method
                VStack(spacing: 15) {
                    Text("Earnings by Payment Method")
                        .font(.headline)
                    if earningsByMethodData.isEmpty {
                        Text("No data available")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        Chart(earningsByMethodData) {
                            BarMark(
                                x: .value("Payment Method", $0.method),
                                y: .value("Amount", $0.amount)
                            )
                            .foregroundStyle(by: .value("Payment Method", $0.method)) // Adds unique colors
                        }
                        .frame(height: 300)
                        .padding()
                    }
                }

                // Earnings Over Time
                VStack(spacing: 15) {
                    Text("Earnings Over Time")
                        .font(.headline)
                    if earningsOverTimeData.isEmpty {
                        Text("No data available")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        Chart(earningsOverTimeData) {
                            LineMark(
                                x: .value("Date", $0.date),
                                y: .value("Amount", $0.amount)
                            )
                            .interpolationMethod(.catmullRom) // Smooths the line
                            .foregroundStyle(.blue) // Set consistent color
                        }
                        .frame(height: 300)
                        .padding()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Earnings Analytics")
        }
    }

    // Computed property for Earnings by Payment Method
    private var earningsByMethodData: [EarningsByMethod] {
        var methodTotals: [PaymentMethod: Double] = [:]

        // Aggregate earnings by payment method
        for payment in appData.payments {
            methodTotals[payment.method, default: 0] += payment.amount
        }

        // Convert to an array of `EarningsByMethod`
        return methodTotals.map { EarningsByMethod(method: $0.key.rawValue, amount: $0.value) }
    }

    // Computed property for Earnings Over Time
    private var earningsOverTimeData: [EarningsOverTime] {
        var dailyTotals: [Date: Double] = [:]

        // Aggregate earnings by day
        for payment in appData.payments {
            let day = Calendar.current.startOfDay(for: payment.date) // Normalize to start of day
            dailyTotals[day, default: 0] += payment.amount
        }

        // Convert to an array of `EarningsOverTime`, sorted by date
        return dailyTotals
            .sorted(by: { $0.key < $1.key }) // Sort by date
            .map { EarningsOverTime(date: $0.key, amount: $0.value) }
    }
}

// Data models for charting
struct EarningsByMethod: Identifiable {
    let id = UUID()
    let method: String
    let amount: Double
}

struct EarningsOverTime: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}
