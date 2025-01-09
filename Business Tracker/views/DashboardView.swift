//import SwiftUI
//
//struct DashboardView: View {
//    @EnvironmentObject var appData: AppData
//    @State private var showHamburgerMenu = false // Toggle for the hamburger menu
//
//    var body: some View {
//        VStack(spacing: 20) {
//            // Header with Hamburger Menu
//            HStack {
//                Button(action: {
//                    showHamburgerMenu.toggle()
//                }) {
//                    Image(systemName: "line.horizontal.3")
//                        .font(.title2)
//                        .foregroundColor(.primary)
//                }
//                Spacer()
//                Text("Dashboard")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                Spacer()
//            }
//            .padding(.horizontal)
//            .padding(.top)
//
//            // Summary Section
//            VStack(spacing: 20) {
//                Text("Overview")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                    .padding(.horizontal)
//
//                HStack(spacing: 20) {
//                    SummaryCard(
//                        title: "Earnings",
//                        value: appData.totalEarnings,
//                        icon: "dollarsign.circle",
//                        color: .green
//                    )
//                    SummaryCard(
//                        title: "Expenses",
//                        value: appData.totalExpenses,
//                        icon: "cart",
//                        color: .red
//                    )
//                }
//                .padding(.horizontal)
//
//                SummaryCard(
//                    title: "Paid to Myself",
//                    value: appData.selfPayments.reduce(0) { $0 + $1.amount },
//                    icon: "person.crop.circle",
//                    color: .blue
//                )
//                .padding(.horizontal)
//            }
//
//            // Detailed Breakdown Section
//            VStack(spacing: 16) {
//                Text("Detailed Breakdown")
//                    .font(.headline)
//                    .padding(.horizontal)
//
//                // Payment Breakdown
//                NavigationLink(
//                    destination: DetailedBreakdownView()
//                ) {
//                    BreakdownRow(title: "Payments", value: appData.totalEarnings, color: .green, exportable: true)
//                }
//
//                // Expense Breakdown
//                NavigationLink(
//                    destination: DetailedBreakdownView()
//                ) {
//                    BreakdownRow(title: "Expenses", value: appData.totalExpenses, color: .red, exportable: true)
//                }
//
//                // Pay Myself Breakdown
//                NavigationLink(
//                    destination: DetailedBreakdownView()
//                ) {
//                    BreakdownRow(title: "Paid to Myself", value: appData.selfPayments.reduce(0) { $0 + $1.amount }, color: .blue, exportable: true)
//                }
//            }
//            .padding(.horizontal)
//
//            Spacer()
//        }
//        .padding()
//        .background(Color(.systemGroupedBackground).ignoresSafeArea())
//        .overlay(
//            // Hamburger Menu
//            Group {
//                if showHamburgerMenu {
//                    HamburgerMenu(showMenu: $showHamburgerMenu)
//                        .transition(.move(edge: .leading))
//                        .zIndex(1)
//                }
//            }
//        )
//        .navigationBarHidden(true)
//    }
//}
//
//// Breakdown Row
//struct BreakdownRow: View {
//    let title: String
//    let value: Double
//    let color: Color
//    let exportable: Bool
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(color)
//                Text("$\(String(format: "%.2f", value))")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//            if exportable {
//                Button(action: {
//                    // Add export functionality here
//                    print("\(title) data exported.")
//                }) {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.title2)
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(radius: 4)
//    }
//}
//
//    
//    struct HamburgerMenu: View {
//        @Binding var showMenu: Bool
//
//        var body: some View {
//            VStack(alignment: .leading, spacing: 20) {
//                // Profile
//                Button(action: {
//                    // Handle profile navigation
//                    showMenu = false
//                }) {
//                    HStack {
//                        Image(systemName: "person.circle")
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                        Text("Profile")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                    }
//                }
//
//                // Settings
//                Button(action: {
//                    // Handle settings navigation
//                    showMenu = false
//                }) {
//                    HStack {
//                        Image(systemName: "gearshape")
//                            .font(.title2)
//                            .foregroundColor(.primary)
//                        Text("Settings")
//                            .font(.headline)
//                            .foregroundColor(.primary)
//                    }
//                }
//
//                // Logout
//                Button(action: {
//                    // Handle logout logic
//                    showMenu = false
//                }) {
//                    HStack {
//                        Image(systemName: "arrow.backward")
//                            .font(.title2)
//                            .foregroundColor(.red)
//                        Text("Logout")
//                            .font(.headline)
//                            .foregroundColor(.red)
//                    }
//                }
//
//                Spacer()
//            }
//            .padding()
//            .frame(maxWidth: 250)
//            .background(Color(.systemGray6))
//            .cornerRadius(12)
//            .shadow(radius: 5)
//            .padding(.leading, 10)
//            .padding(.top, 60) // Adjust to align with your app's header
//        }
//    }
//
//
