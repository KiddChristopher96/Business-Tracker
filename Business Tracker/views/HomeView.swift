import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appData: AppData
    @Binding var selectedTab: Int // Binding to control the selected tab

    var body: some View {
        ZStack {
            // Background that spans the entire view
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 30) {
                    // Welcome Header
                    VStack(spacing: 12) {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Text("Here's an overview of your business.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20) // Reduced padding to remove white space

                    // Summary Section
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            NavigationLink(destination: PaymentListView(payments: appData.payments)) {
                                SummaryCard(
                                    title: "Earnings",
                                    value: appData.totalEarnings,
                                    icon: "dollarsign.circle",
                                    color: .green
                                )
                            }

                            NavigationLink(destination: ExpenseListView(expenses: appData.expenses)) {
                                SummaryCard(
                                    title: "Expenses",
                                    value: appData.totalExpenses,
                                    icon: "cart",
                                    color: .red
                                )
                            }
                        }

                        NavigationLink(destination: SelfPaymentListView(selfPayments: appData.selfPayments)) {
                            SummaryCard(
                                title: "Paid to Myself",
                                value: appData.selfPayments.reduce(0) { $0 + $1.amount },
                                icon: "person.crop.circle",
                                color: .blue
                            )
                        }

                        // Net Profit Card
                        SummaryCard(
                            title: "Net Profit",
                            value: appData.totalEarnings - appData.totalExpenses - appData.selfPayments.reduce(0) { $0 + $1.amount },
                            icon: "arrow.up.right.circle",
                            color: .purple
                        )
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
            }
        }
        .navigationBarHidden(true) // Hides navigation bar to prevent extra spacing
    }

    private func getRecentTransactions() -> [Transaction] {
        let payments = appData.payments.map { $0.toTransaction() }
        let expenses = appData.expenses.map { $0.toTransaction() }
        let selfPayments = appData.selfPayments.map { $0.toTransaction() }
        return (payments + expenses + selfPayments).sorted { $0.date > $1.date }
    }

    private func getTransactionColor(transaction: Transaction) -> Color {
        switch transaction.description {
        case "Paid to Myself":
            return .blue
        case "Expense":
            return .red
        default:
            return .green
        }
    }
}

// MARK: - Summary Card
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

// MARK: - Quick Action Button
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

// MARK: - Activity Card
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

// MARK: - Filter Type Enum
enum FilterType: String, CaseIterable {
    case all = "All"
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    case year = "This Year"
}

// MARK: - Transaction Model
struct Transaction: Identifiable, Codable {
    let id = UUID()
    let description: String
    let date: Date
    let amount: Double
}

// MARK: - Extensions to Convert to Transaction
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

// MARK: - Recent Activity View
struct RecentActivityView: View {
    @State private var selectedFilter: FilterType = .all
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var filteredData: [Transaction] = []
    @State private var showDocumentPicker = false
    @State private var pendingFileURL: URL?
    let data: [Transaction]

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // Quick Filter Picker
                Picker("Quick Filter", selection: $selectedFilter) {
                    ForEach(FilterType.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedFilter) { _ in applyQuickFilter() }

                // Date Range Picker
                VStack(spacing: 10) {
                    HStack {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .labelsHidden()
                        Text("-")
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .labelsHidden()
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .onChange(of: startDate) { _ in applyDateRangeFilter() }
                .onChange(of: endDate) { _ in applyDateRangeFilter() }

                // Export Button
                Button(action: exportFilteredData) {
                    Text("Export Filtered Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                if filteredData.isEmpty {
                    Spacer()
                    Text("No transactions found.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List(filteredData) { transaction in
                        HStack {
                            Text(transaction.description)
                                .font(.headline)
                            Spacer()
                            Text("$\(String(format: "%.2f", transaction.amount))")
                                .foregroundColor(getTransactionColor(transaction))
                        }
                    }
                }
            }
            .onAppear {
                applyQuickFilter()
            }
        }
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPickerHomeView(fileURL: pendingFileURL)
        }
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

    private func applyDateRangeFilter() {
        filteredData = data.filter { $0.date >= startDate && $0.date <= endDate }
    }

    private func getTransactionColor(_ transaction: Transaction) -> Color {
        switch transaction.description {
        case "Paid to Myself":
            return .blue
        case "Expense":
            return .red
        default:
            return .green
        }
    }

    private func exportFilteredData() {
        saveToFile(data: filteredData, fileName: "FilteredTransactions.json")
    }

    private func saveToFile<T: Codable>(data: [T], fileName: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: Makes JSON more readable
        encoder.dateEncodingStrategy = .iso8601  // Formats dates in ISO8601

        do {
            let jsonData = try encoder.encode(data)
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try jsonData.write(to: tempURL)

            pendingFileURL = tempURL
            showDocumentPicker = true
        } catch {
            print("Failed to save file: \(error.localizedDescription)")
        }
    }
}

// MARK: - Document Picker
struct DocumentPickerHomeView: UIViewControllerRepresentable {
    let fileURL: URL?

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forExporting: [fileURL].compactMap { $0 })
        return controller
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}
