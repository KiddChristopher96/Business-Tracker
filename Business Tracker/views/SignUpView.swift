import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @Environment(\.colorScheme) var colorScheme // Detect light/dark mode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 30) {
            // Header with Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Navigate back to Login View
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                        Text("Back")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)

            // Title
            Text("Create Account")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top)

            // Sign-Up Form
            VStack(spacing: 20) {
                CustomTextFieldSignUp(
                    placeholder: "Email",
                    text: $email,
                    icon: "envelope",
                    isSecure: false
                )

                CustomTextFieldSignUp(
                    placeholder: "Password",
                    text: $password,
                    icon: "lock",
                    isSecure: true
                )

                CustomTextFieldSignUp(
                    placeholder: "Confirm Password",
                    text: $confirmPassword,
                    icon: "lock",
                    isSecure: true
                )

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal)

            // Sign-Up Button
            Button(action: {
                guard password == confirmPassword else {
                    errorMessage = "Passwords do not match"
                    return
                }
                authManager.signUp(email: email, password: password) { error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        presentationMode.wrappedValue.dismiss() // Close Sign-Up View
                    }
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        email.isEmpty || password.isEmpty || confirmPassword.isEmpty
                            ? Color.gray
                            : Color.green
                    )
                    .cornerRadius(12)
                    .shadow(color: shadowColor(), radius: 5, x: 0, y: 3)
            }
            .disabled(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            .padding(.horizontal)

            Spacer()

            // Footer
            VStack(spacing: 10) {
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Go back to Login View
                    }) {
                        Text("Sign In")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(
            backgroundColor()
                .ignoresSafeArea(.all, edges: .bottom)
        )
        .ignoresSafeArea(.keyboard, edges: .bottom) // Handles keyboard appearance gracefully
    }

    // Dynamically adapt the background based on light/dark mode
    private func backgroundColor() -> Color {
        colorScheme == .dark ? Color.black.opacity(0.9) : Color.white
    }

    // Dynamically adapt the shadow color based on light/dark mode
    private func shadowColor() -> Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)
    }
}

// Reusable Custom TextField Component
struct CustomTextFieldSignUp: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    let isSecure: Bool
    @Environment(\.colorScheme) var colorScheme // Detect light/dark mode

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .textContentType(isSecure ? .password : .emailAddress)
                    .foregroundColor(.primary)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .textContentType(isSecure ? .password : .emailAddress)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(.systemGray5) : Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: shadowColor(), radius: 5, x: 0, y: 2)
    }

    private func shadowColor() -> Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1)
    }
}
