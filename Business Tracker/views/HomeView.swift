import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @Binding var selectedTab: Int // Binding to control the selected tab

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Back Header
                    VStack {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Here's an overview of your business")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)

                    // Summary Cards
                    HStack(spacing: 15) {
                        SummaryCard(
                            title: "Earnings",
                            value: appData.payments.reduce(0) { $0 + $1.amount },
                            icon: "dollarsign.circle",
                            color: .green
                        )
                        SummaryCard(
                            title: "Expenses",
                            value: appData.expenses.reduce(0) { $0 + $1.amount },
                            icon: "cart",
                            color: .red
                        )
                    }
                    
                    HStack(spacing: 15) {
                        SummaryCard(
                            title: "Paid to Myself",
                            value: appData.selfPayments.reduce(0) { $0 + $1.amount },
                            icon: "person.crop.circle",
                            color: .blue
                        )
                        SummaryCard(
                            title: "Net Profit",
                            value: appData.payments.reduce(0) { $0 + $1.amount }
                                - appData.expenses.reduce(0) { $0 + $1.amount }
                                - appData.selfPayments.reduce(0) { $0 + $1.amount },
                            icon: "chart.bar",
                            color: .purple
                        )
                    }

                    // Quick Links
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.top)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            selectedTab = 1 // Navigate to Add Payment tab
                        }) {
                            QuickActionButton(title: "Add Payment", icon: "plus.circle", color: .blue)
                        }
                        Button(action: {
                            selectedTab = 2 // Navigate to Add Expense tab
                        }) {
                            QuickActionButton(title: "Add Expense", icon: "minus.circle", color: .red)
                        }
                        Button(action: {
                            selectedTab = 3 // Navigate to Pay Myself tab
                        }) {
                            QuickActionButton(title: "Pay Myself", icon: "dollarsign.circle", color: .green)
                        }
                    }

                    // Recent Activity
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.top)

                    VStack(spacing: 10) {
                        if appData.payments.isEmpty && appData.expenses.isEmpty && appData.selfPayments.isEmpty {
                            Text("No recent activity recorded.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(appData.payments.prefix(3)) { payment in
                                ActivityCard(
                                    title: "\(payment.method.rawValue) Payment",
                                    amount: payment.amount,
                                    date: payment.date,
                                    color: .green
                                )
                            }
                            ForEach(appData.expenses.prefix(3)) { expense in
                                ActivityCard(
                                    title: "Expense",
                                    amount: expense.amount,
                                    date: expense.date,
                                    color: .red
                                )
                            }
                            ForEach(appData.selfPayments.prefix(3)) { payment in
                                ActivityCard(
                                    title: "Paid to Myself",
                                    amount: payment.amount,
                                    date: payment.date,
                                    color: .blue
                                )
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle("")
            }
        }
    }
}

// Summary Card Component
struct SummaryCard: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color

    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(color)
                Spacer()
                Text("$\(String(format: "%.2f", value))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .lineLimit(1) // Prevents overflow
                    .minimumScaleFactor(0.5) // Scales down if the text is too long
            }
            .padding()
            
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 100) // Increased height for better spacing
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

// Quick Action Button Component
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(width: 100, height: 100)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

// Activity Card Component
struct ActivityCard: View {
    let title: String
    let amount: Double
    let date: Date
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                Text("Amount: $\(String(format: "%.2f", amount))")
                Text("Date: \(date, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(0)).environmentObject(AppData())
    }
}
