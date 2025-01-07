import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Summary Cards
                VStack(spacing: 15) {
                    SummaryCard(
                        title: "Total Earnings",
                        value: appData.totalEarnings,
                        icon: "dollarsign.circle",
                        color: .green
                    )
                    SummaryCard(
                        title: "Total Expenses",
                        value: appData.totalExpenses,
                        icon: "cart",
                        color: .red
                    )
                    SummaryCard(
                        title: "Net Profit",
                        value: appData.netProfit,
                        icon: "chart.bar",
                        color: .blue
                    )
                }

                // Navigation Buttons for Analytics
                VStack(spacing: 20) {
                    NavigationLink(destination: EarningsAnalyticsView()) {
                        DashboardButton(
                            title: "View Earnings Analytics",
                            icon: "chart.bar"
                        )
                    }

                    NavigationLink(destination: DetailedBreakdownView()) {
                        DashboardButton(
                            title: "View Detailed Breakdown",
                            icon: "list.bullet"
                        )
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

// Dashboard Button Component
struct DashboardButton: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
