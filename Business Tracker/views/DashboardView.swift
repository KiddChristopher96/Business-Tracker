import SwiftUI

struct DashboardView: View {
    @State private var isHamburgerOpen = false // Track the menu state

    var body: some View {
        ZStack {
            // Full-screen background
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
                }
                .padding(.horizontal)
                .padding(.top, 20) // Adjust top padding to align the header properly

                // Main Dashboard Content
                ScrollView {
                    VStack(spacing: 20) {
                        // Placeholder for future dashboard content
                        Text("Dashboard Content Here")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding()

                        Text("Add your analytics, charts, or summaries here.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
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
        .navigationBarHidden(true) // Remove navigation bar to avoid extra white space
    }
}


            

