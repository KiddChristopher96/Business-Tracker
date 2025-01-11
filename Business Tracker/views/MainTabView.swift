import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0 // Tracks the currently selected tab

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomeView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)

            NavigationView {
                AddPaymentView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Add Payment", systemImage: "plus.circle")
            }
            .tag(1)

            NavigationView {
                AddExpenseView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Add Expense", systemImage: "minus.circle")
            }
            .tag(2)

            NavigationView {
                PayMyselfView(selectedTab: $selectedTab)
            }
            .tabItem {
                Label("Pay Myself", systemImage: "dollarsign.circle")
            }
            .tag(3)

            NavigationView {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "chart.bar")
            }
            .tag(4)
        }
        .accentColor(.blue)
    }
}
