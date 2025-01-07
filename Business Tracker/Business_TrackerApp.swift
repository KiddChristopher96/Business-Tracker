import SwiftUI

@main
struct BusinessTrackerApp: App {
    @StateObject private var appData = AppData()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appData)
        }
    }
}
