import SwiftUI

struct ProfileView: View {
    @State private var businessName: String = "Your Business"
    @State private var contactInfo: String = "contact@business.com"

    var body: some View {
        Form {
            Section(header: Text("Business Info")) {
                TextField("Business Name", text: $businessName)
                TextField("Contact Info", text: $contactInfo)
            }
        }
        .navigationTitle("Profile")
    }
}
