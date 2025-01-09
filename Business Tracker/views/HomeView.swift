import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @Binding var selectedTab: Int // Binding to control the selected tab

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Welcome Header
                    VStack(spacing: 12) {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Here's an overview of your business")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)

                    // Summary Cards
                    VStack(spacing: 20) {
                        NavigationLink(destination: PaymentListView(payments: appData.payments)) {
                            SummaryCard(
                                title: "Earnings",
                                value: appData.payments.reduce(0) { $0 + $1.amount },
                                icon: "dollarsign.circle",
                                color: .green
                            )
                        }

                        NavigationLink(destination: ExpenseListView(expenses: appData.expenses)) {
                            SummaryCard(
                                title: "Expenses",
                                value: appData.expenses.reduce(0) { $0 + $1.amount },
                                icon: "cart",
                                color: .red
                            )
                        }

                        NavigationLink(destination: SelfPaymentListView(selfPayments: appData.selfPayments)) {
                            SummaryCard(
                                title: "Paid to Myself",
                                value: appData.selfPayments.reduce(0) { $0 + $1.amount },
                                icon: "person.crop.circle",
                                color: .blue
                            )
                        }
                    }
                    .padding(.horizontal)

                    // Quick Actions
                    VStack(spacing: 20) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)

                        HStack(spacing: 20) {
                            QuickActionButton(title: "Add Payment", icon: "plus.circle", color: .green) {
                                selectedTab = 1
                            }
                            QuickActionButton(title: "Add Expense", icon: "minus.circle", color: .red) {
                                selectedTab = 2
                            }
                            QuickActionButton(title: "Pay Myself", icon: "dollarsign.circle", color: .blue) {
                                selectedTab = 3
                            }
                        }
                    }
                    .padding(.horizontal)

                    // Recent Activity Section
                    VStack(spacing: 16) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.horizontal)

                        if appData.payments.isEmpty && appData.expenses.isEmpty && appData.selfPayments.isEmpty {
                            Text("No recent activity recorded.")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(getRecentTransactions().prefix(5)) { transaction in
                                    ActivityCard(
                                        title: transaction.description,
                                        amount: transaction.amount,
                                        date: transaction.date,
                                        color: getTransactionColor(transaction: transaction)
                                    )
                                }
                                NavigationLink(destination: RecentActivityView(data: getRecentTransactions())) {
                                    Text("View All")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                        .padding(.top, 10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
            }
            .navigationBarHidden(true)
        }
    }

    private func getRecentTransactions() -> [Transaction] {
        let payments = appData.payments.map { $0.toTransaction() }
        let expenses = appData.expenses.map { $0.toTransaction() }
        let selfPayments = appData.selfPayments.map { $0.toTransaction() }
        return (payments + expenses + selfPayments).sorted { $0.date > $1.date }
    }

    private func getTransactionColor(transaction: Transaction) -> Color {
        if transaction.description == "Paid to Myself" {
            return .blue
        } else if transaction.description == "Expense" {
            return .red
        } else {
            return .green
        }
    }
}

// Summary Card
struct SummaryCard: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("$\(String(format: "%.2f", value))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            Spacer()
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(color)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}

// Quick Action Button
struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
        }
    }
}

// Activity Card
struct ActivityCard: View {
    let title: String
    let amount: Double
    let date: Date
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
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
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}

// Recent Activity View
struct RecentActivityView: View {
    @State private var selectedFilter: FilterType = .all // Quick filter
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var filteredData: [Transaction] = []
    let data: [Transaction]

    var body: some View {
        VStack(spacing: 16) {
            // Quick Filter Picker
            VStack(spacing: 10) {
                Picker("Quick Filter", selection: $selectedFilter) {
                    ForEach(FilterType.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedFilter) { _ in
                    applyQuickFilter()
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding()

            // Filtered List
            if filteredData.isEmpty {
                Text("No transactions found for the selected filter.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(filteredData) { transaction in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(transaction.description)
                                .font(.headline)
                            Text("\(transaction.date, style: .date)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("$\(String(format: "%.2f", transaction.amount))")
                            .font(.headline)
                            .foregroundColor(transaction.amount < 0 ? .red : .green)
                    }
                }
            }
        }
        .onAppear {
            initializeDateRange()
            applyQuickFilter()
        }
        .navigationTitle("Recent Activity")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }

    private func applyQuickFilter() {
        switch selectedFilter {
        case .all:
            filteredData = data
        case .today:
            filteredData = data.filter { Calendar.current.isDateInToday($0.date) }
        case .week:
            filteredData = data.filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
            }
        case .month:
            filteredData = data.filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month)
            }
        case .year:
            filteredData = data.filter {
                Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .year)
            }
        }
    }

    private func initializeDateRange() {
        startDate = getEarliestDate()
        endDate = Date()
    }

    private func getEarliestDate() -> Date {
        return data.map { $0.date }.min() ?? Date()
    }
}

// Filter Type Enum
enum FilterType: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    case year = "This Year"
}

// Transaction Model
struct Transaction: Identifiable {
    let id = UUID()
    let description: String
    let date: Date
    let amount: Double
}

// Extensions to Convert to Transaction
extension Payment {
    func toTransaction() -> Transaction {
        return Transaction(description: method, date: date, amount: amount)
    }
}

extension Expense {
    func toTransaction() -> Transaction {
        return Transaction(description: "Expense", date: date, amount: amount)
    }
}

extension SelfPayment {
    func toTransaction() -> Transaction {
        return Transaction(description: "Paid to Myself", date: date, amount: amount)
    }
}


// Detailed View for Each Card

struct DetailedView: View {
    let title: String
    let data: [Transaction]

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if data.isEmpty {
                Text("No \(title.lowercased()) data available.")
                    .foregroundColor(.gray)
            } else {
                List(data) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.description)
                                .font(.headline)
                            Text("\(transaction.date, style: .date)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("$\(String(format: "%.2f", transaction.amount))")
                            .font(.headline)
                            .foregroundColor(title == "Expenses" ? .red : .green)
                    }
                }
            }
        }
        .navigationTitle(title)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
