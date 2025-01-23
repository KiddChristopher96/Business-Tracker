import SwiftUI

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme // Detect dark or light mode
    @State private var isHamburgerOpen = false // Track the menu state

    var body: some View {
        ZStack {
            // Background color
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation {
                            isHamburgerOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    Text("Dashboard")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .padding(.horizontal)
                .padding(.top, 20)

                // Main Dashboard Content
                ScrollView {
                    VStack(spacing: 20) {
                        SectionHeader(title: "Your Analytics")

                        // Dynamic cards
                        DashboardCard(
                            icon: "chart.bar",
                            title: "Income & Expenses",
                            subtitle: "Track your earnings and spending",
                            backgroundColor: dynamicColor(light: .blue, dark: .teal)
                        ) {
                            print("Income & Expenses tapped")
                        }

                        DashboardCard(
                            icon: "dollarsign.circle",
                            title: "Payments",
                            subtitle: "Overview of all payments",
                            backgroundColor: dynamicColor(light: .green, dark: .mint)
                        ) {
                            print("Payments tapped")
                        }

                        DashboardCard(
                            icon: "cart",
                            title: "Expenses",
                            subtitle: "Analyze your business expenses",
                            backgroundColor: dynamicColor(light: .red, dark: .pink)
                        ) {
                            print("Expenses tapped")
                        }

                        DashboardCard(
                            icon: "chart.pie",
                            title: "Analytics",
                            subtitle: "Detailed business insights",
                            backgroundColor: dynamicColor(light: .purple, dark: .indigo)
                        ) {
                            print("Analytics tapped")
                        }
                    }
                    .padding(.horizontal)
                }
            }

            // Hamburger Menu Overlay
            if isHamburgerOpen {
                HamburgerMenu(isOpen: $isHamburgerOpen)
                    .transition(.move(edge: .leading))
            }
        }
        .navigationBarHidden(true)
    }

    private func dynamicColor(light: Color, dark: Color) -> Color {
        colorScheme == .dark ? dark : light
    }
}

// MARK: - Section Header
struct SectionHeaderDashboard: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

// MARK: - Dashboard Card
struct DashboardCard: View {
    @Environment(\.colorScheme) var colorScheme // Detect dark or light mode
    let icon: String
    let title: String
    let subtitle: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(backgroundColor))
                    .frame(width: 60, height: 60)

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
            .background(colorScheme == .dark ? Color(.secondarySystemGroupedBackground) : Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}
