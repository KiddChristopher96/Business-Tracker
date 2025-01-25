import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import PhotosUI
import Foundation
import FirebaseStorage

struct GeneralSettingsView: View {
    @State private var profileName: String = ""
    @State private var businessName: String = ""
    @State private var email: String = ""
    @State private var showSuccessAlert: Bool = false
    @State private var profileImage: UIImage? = nil // For holding the selected profile image
    @State private var showPhotoPicker: Bool = false
    
    // Firestore reference
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Edit Profile")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            
            // Profile Picture Section
            VStack(spacing: 10) {
                if let profileImage = profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                }
                
                Button(action: { showPhotoPicker.toggle() }) {
                    Text("Edit picture or avatar")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom)
            
            // Form-like structure
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Section
                    SettingsSection {
                        SettingsRow(title: "Name", value: $profileName)
                        SettingsRow(title: "Email", value: $email)
                    }
                    
                    // Business Section
                    SettingsSection {
                        SettingsRow(title: "Business Name", value: $businessName)
                    }
                }
                .padding()
            }
            
            // Save Button
            Button(action: saveChanges) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
                    .padding(.horizontal)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear(perform: fetchSettings)
        .alert(isPresented: $showSuccessAlert) {
            Alert(title: Text("Success"),
                  message: Text("Your profile has been updated."),
                  dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showPhotoPicker) {
            PhotoPicker(selectedImage: $profileImage)
        }
    }
    
    private func saveChanges() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            return
        }
        
        if let profileImage = profileImage {
            // Upload image first before saving text fields
            uploadProfileImage(userID: userID, image: profileImage) { success in
                if success {
                    // Save text fields only after image upload completes
                    saveUserSettings(userID: userID)
                }
            }
        } else {
            // No image to upload, directly save text fields
            saveUserSettings(userID: userID)
        }
    }
    
    private func saveUserSettings(userID: String) {
        let userSettings: [String: Any] = [
            "profileName": profileName,
            "businessName": businessName,
            "email": email
        ]
        
        db.collection("users").document(userID).setData(userSettings, merge: true) { error in
            if let error = error {
                print("Error saving settings: \(error.localizedDescription)")
            } else {
                print("Settings saved successfully!")
                showSuccessAlert = true
            }
        }
    }
    
    private func uploadProfileImage(userID: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        // Path includes the userId and fileName
        let fileName = "profile.jpg"
        let storageRef = Storage.storage().reference().child("profile_images/\(userID)/\(fileName)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: Failed to convert UIImage to JPEG data.")
            completion(false)
            return
        }
        
        // Upload the image to the correct path
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Profile image uploaded successfully!")
                
                // Fetch the download URL to confirm the upload
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error fetching download URL: \(error.localizedDescription)")
                        completion(false)
                    } else if let url = url {
                        print("Download URL fetched successfully: \(url.absoluteString)")
                        completion(true)
                    }
                }
            }
        }
    }
    
    private func fetchSettings() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: User not logged in.")
            return
        }
        
        // Fetch user settings
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching settings: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                let data = document.data()
                self.profileName = data?["profileName"] as? String ?? ""
                self.businessName = data?["businessName"] as? String ?? ""
                self.email = data?["email"] as? String ?? ""
                print("Settings fetched successfully!")
            } else {
                print("No settings document found.")
            }
        }
        
        // Fetch profile image
        fetchProfileImage(userID: userID)
    }
    
    private func fetchProfileImage(userID: String) {
        let fileName = "profile.jpg"
        let storageRef = Storage.storage().reference().child("profile_images/\(userID)/\(fileName)")
        
        storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let error = error as NSError? {
                if error.domain == StorageErrorDomain && error.code == StorageErrorCode.objectNotFound.rawValue {
                    print("Profile image does not exist for user \(userID). Setting to placeholder.")
                    self.profileImage = nil // Use a system placeholder or nil
                } else {
                    print("Error fetching profile image: \(error.localizedDescription)")
                }
            } else if let data = data, let image = UIImage(data: data) {
                self.profileImage = image
                print("Profile image fetched successfully!")
            }
        }
    }
}




// MARK: - Components
struct SettingsSection<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        VStack(spacing: 10) {
            content()
        }
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct SettingsRow: View {
    let title: String
    @Binding var value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            TextField("", text: $value)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.primary)
                .padding(.leading, 10)
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

// MARK: - Photo Picker Component
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.selectedImage = image as? UIImage
                }
            }
        }
    }
}
