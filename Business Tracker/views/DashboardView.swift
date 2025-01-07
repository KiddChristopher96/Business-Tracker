import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    @EnvironmentObject var appData: AppData
    @State private var isMenuOpen: Bool = false // Tracks if the menu is open
    @State private var isLoggedOut: Bool = false // Tracks logout state

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
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
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isMenuOpen = true // Show the menu as a full-screen view
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.primary) // Dynamic for dark/light mode
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isMenuOpen) {
                FullScreenMenuView(isMenuOpen: $isMenuOpen, isLoggedOut: $isLoggedOut)
            }
            .fullScreenCover(isPresented: $isLoggedOut) {
                LoginView() // Replace with your LoginView
            }
        }
    }
}

// Full-Screen Menu View
struct FullScreenMenuView: View {
    @Binding var isMenuOpen: Bool
    @Binding var isLoggedOut: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Close Button
                HStack {
                    Button(action: {
                        isMenuOpen = false // Close the menu
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.primary) // Dynamic for dark/light mode
                    }
                    Spacer()
                }
                .padding()

                // Menu Title
                Text("Menu")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Menu Options
                VStack(spacing: 10) {
                    NavigationLink(destination: ProfileView()) {
                        MenuOption(title: "Profile", icon: "person.circle")
                    }
                    Button(action: {
                        logout()
                    }) {
                        MenuOption(title: "Logout", icon: "arrow.backward.circle")
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 20)
            .background(Color(.systemBackground).ignoresSafeArea()) // Matches system theme
        }
    }

    // Logout Functionality
    private func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true // Redirect to login screen
            isMenuOpen = false // Close the menu
        } catch {
            print("Error logging out: \(error.localizedDescription)")
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
                .foregroundColor(.primary) // Dynamic for dark/light mode
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6)) // Matches system theme
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

// Menu Option Component
struct MenuOption: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary) // Dynamic for dark/light mode
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6)) // Matches system theme
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
