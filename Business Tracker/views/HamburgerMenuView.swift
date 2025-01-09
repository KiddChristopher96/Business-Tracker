//import SwiftUI
//
//struct HamburgerMenuView: View {
//    @Binding var isMenuOpen: Bool
//
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading, spacing: 20) {
//                // Close Button
//                HStack {
//                    Button(action: {
//                        withAnimation {
//                            isMenuOpen = false
//                        }
//                    }) {
//                        Image(systemName: "xmark")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                    }
//                    Spacer()
//                }
//                .padding()
//
//                // Menu Header
//                Text("Menu")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding(.horizontal)
//
//                // Menu Items
//                VStack(spacing: 15) {
//                    NavigationLink(destination: ProfileView()) {
//                        MenuItem(title: "Profile", icon: "person.circle")
//                    }
//                }
//                .padding(.horizontal)
//
//                Spacer()
//            }
//            .padding(.top, 20)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.white)
//            .ignoresSafeArea()
//            .navigationTitle("") // Clear navigation title
//            .navigationBarHidden(true) // Hide the navigation bar
//        }
//    }
//}
//
//struct MenuItem: View {
//    let title: String
//    let icon: String
//
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//                .font(.title2)
//                .foregroundColor(.blue)
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.primary)
//            Spacer()
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .shadow(radius: 3)
//    }
//}
