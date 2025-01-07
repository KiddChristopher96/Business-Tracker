import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var showSignUp = false // Controls navigation to Sign Up View

    var body: some View {
        VStack(spacing: 30) {
            // App Title
            Text("Expensify")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            // Login Form
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 2)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 2)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal)

            // Sign In Button
            Button(action: {
                authManager.signIn(email: email, password: password) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            // Spacer to Push Content Up
            Spacer()

            // Sign-Up or Help Link
            HStack {
                Text("Don't have an account?")
                Button(action: {
                    showSignUp = true // Navigate to Sign Up
                }) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom)
        }
        .padding()
        .background(Color(.systemBackground)) // Matches app's background
        .ignoresSafeArea(.keyboard) // Handles keyboard appearance gracefully
        .sheet(isPresented: $showSignUp) {
            SignUpView() // Display the Sign-Up View
        }
    }
}
