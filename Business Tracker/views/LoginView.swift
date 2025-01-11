import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.colorScheme) var colorScheme // Detect light/dark mode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var showSignUp = false // Controls navigation to Sign Up View
    @State private var showForgotPassword = false // Controls navigation to Forgot Password View

    var body: some View {
        VStack(spacing: 30) {
            // Header
            Text("Expensify")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.top)

            // Sub-Header
            Text("Manage your payments and expenses effortlessly.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Login Form
            VStack(spacing: 20) {
                CustomTextFieldLogin(
                    placeholder: "Email",
                    text: $email,
                    icon: "envelope",
                    isSecure: false
                )

                CustomTextFieldLogin(
                    placeholder: "Password",
                    text: $password,
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

                // Forgot Password Link
                Button(action: {
                    showForgotPassword = true
                }) {
                    Text("Forgot your password?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 5)
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
                    .background(
                        email.isEmpty || password.isEmpty
                            ? Color.gray
                            : Color.blue
                    )
                    .cornerRadius(12)
                    .shadow(color: shadowColor(), radius: 5, x: 0, y: 3)
            }
            .disabled(email.isEmpty || password.isEmpty)
            .padding(.horizontal)

            Spacer()

            // Footer with Sign-Up Navigation
            VStack(spacing: 10) {
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Button(action: {
                        showSignUp = true // Navigate to Sign Up
                    }) {
                        Text("Sign Up")
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
        .sheet(isPresented: $showSignUp) {
            SignUpView() // Display the Sign-Up View
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView() // Display the Forgot Password View
        }
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
struct CustomTextFieldLogin: View {
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

// Forgot Password View
struct ForgotPasswordView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("Enter your email to receive a password reset link.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            CustomTextFieldLogin(
                placeholder: "Email",
                text: .constant(""), // Replace with actual binding
                icon: "envelope",
                isSecure: false
            )
            .padding(.horizontal)

            Button(action: {
                // Add reset password logic
                print("Reset password link sent")
            }) {
                Text("Send Reset Link")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
    }
}
