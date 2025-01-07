import SwiftUI
import Firebase

@main
struct BusinessTrackerApp: App {
    @StateObject private var appData = AppData()
    @StateObject private var authManager = AuthenticationManager() // Create AuthenticationManager instance

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authManager.user != nil {
                MainTabView()
                    .environmentObject(appData)
                    .environmentObject(authManager) // Pass authManager to the environment
            } else {
                LoginView() // Show a login screen if not authenticated
                    .environmentObject(authManager)
            }
        }
    }
}
