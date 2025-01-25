import SwiftUI

struct DashboardView: View {
    @Environment(\.colorScheme) var colorScheme // Detect dark or light mode
    @State private var isHamburgerOpen = false // Track the menu state

    var body: some View {
        ZStack {
            // Background color
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack {
                // Header with Hamburger Menu
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
                .padding(.top, 20)

                Spacer()

                // "CRM Coming Soon" Message
                Text("CRM Coming Soon")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Spacer()
            }

            // Hamburger Menu Overlay
            if isHamburgerOpen {
                HamburgerMenu(isOpen: $isHamburgerOpen)
                    .transition(.move(edge: .leading))
            }
        }
        .navigationBarHidden(true)
    }
}


