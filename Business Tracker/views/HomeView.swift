import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @Binding var selectedTab: Int // Binding to control the selected tab

    var body: some View {
        NavigationView {
                   ScrollView {
                       VStack(spacing: 20) {
                           // Welcome Header
                           VStack(spacing: 20) {
                               VStack(spacing: 5) {
                                   Text("Welcome Back!")
                                       .font(.largeTitle)
                                       .fontWeight(.bold)
                                       .multilineTextAlignment(.center)
                                   Text("Here's an overview of your business")
                                       .font(.subheadline)
                                       .foregroundColor(.secondary)
                               }
                               .padding(.bottom, 20)
                               .padding(.top, -20) // Adjust top padding to reduce space
                           }
                           .ignoresSafeArea(edges: .top) // Ignore safe area at the top
                           .navigationBarHidden(true) // Hide navigation bar

                           // Summary Cards
                           VStack(spacing: 15) {
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

                    // Quick Actions
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.top)

                    HStack(spacing: 15) {
                        QuickActionButton(title: "Add Payment", icon: "plus.circle", color: .blue) {
                            selectedTab = 1
                        }
                        QuickActionButton(title: "Add Expense", icon: "minus.circle", color: .red) {
                            selectedTab = 2
                        }
                        QuickActionButton(title: "Pay Myself", icon: "dollarsign.circle", color: .green) {
                            selectedTab = 3
                        }
                    }
                    .padding(.horizontal)

                    // Recent Activity Section
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.top)

                    VStack(spacing: 10) {
                        if appData.payments.isEmpty && appData.expenses.isEmpty && appData.selfPayments.isEmpty {
                            Text("No recent activity recorded.")
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        } else {
                            ForEach(getRecentTransactions().prefix(5)) { transaction in
                                ActivityCard(
                                    title: transaction.description,
                                    amount: transaction.amount,
                                    date: transaction.date,
                                    color: .green
                                )
                            }
                        }
                        NavigationLink(destination: RecentActivityView(data: getRecentTransactions())) {
                            Text("View All")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.top, 10)
                        }
                    }
                }
                .padding()
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
}


struct RecentActivityView: View {
    @State private var selectedFilter: FilterType = .all // Quick filter
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var filteredData: [Transaction] = []
    let data: [Transaction]

    var body: some View {
        VStack {
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

            // Date Range Picker
            VStack(spacing: 10) {
                Text("Or Filter by Date Range")
                    .font(.headline)

                HStack {
                    DatePicker("Start Date", selection: $startDate, in: getEarliestDate()...Date(), displayedComponents: .date)
                        .labelsHidden()
                    Text("to")
                    DatePicker("End Date", selection: $endDate, in: getEarliestDate()...Date(), displayedComponents: .date)
                        .labelsHidden()
                }
                .padding(.horizontal)

                Button(action: applyDateRangeFilter) {
                    Text("Apply Date Range Filter")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding()

            // Filtered List
            if filteredData.isEmpty {
                Text("No transactions found for the selected filter.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(filteredData) { transaction in
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

    // Quick Filter Logic
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

    // Date Range Filter Logic
    private func applyDateRangeFilter() {
        filteredData = data.filter { transaction in
            transaction.date >= startDate && transaction.date <= endDate
        }
    }

    // Initialize Start and End Date Based on Data
    private func initializeDateRange() {
        startDate = getEarliestDate()
        endDate = Date()
    }

    // Get Earliest Transaction Date
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




// Components

struct SummaryCard: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("$\(String(format: "%.2f", value))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            Spacer()
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(color)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
    }
}

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
        return Transaction(description: method.rawValue, date: date, amount: amount)
    }
}

extension Expense {
    func toTransaction() -> Transaction {
        return Transaction(description: "Expense", date: date, amount: amount) // Adjust as needed
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
