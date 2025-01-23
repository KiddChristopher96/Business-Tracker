import SwiftUI

struct GeneralSettingsView: View {
    @State private var profileName: String = ""
    @State private var businessName: String = ""
    @State private var email: String = ""

    var body: some View {
        Form {
            Section(header: Text("Profile")) {
                TextField("Name", text: $profileName)
                    .textContentType(.name)
                    .autocapitalization(.words)

                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
            }

            Section(header: Text("Business")) {
                TextField("Business Name", text: $businessName)
                    .autocapitalization(.words)
            }

            Section {
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("General Settings")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, 10)
    }

    private func saveChanges() {
        print("Profile Name: \(profileName)")
        print("Business Name: \(businessName)")
        print("Email: \(email)")
    }
}
