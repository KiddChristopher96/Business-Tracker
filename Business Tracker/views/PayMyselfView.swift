import SwiftUI

struct PayMyselfView: View {
    @EnvironmentObject var appData: AppData
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var notes: String = ""
    @Binding var selectedTab: Int // Binding to control the selected tab

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    selectedTab = 0 // Navigate back to Home tab
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Pay Myself")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()

            // Amount Input
            HStack {
                Text("$")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.blue) // Matches the "Paid to Myself" color
                TextField("0", text: $amount)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)

            // Date Picker
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.primary)
                Text("Date")
                    .font(.headline)
                Spacer()
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)

            // Notes Input
            VStack(alignment: .leading, spacing: 15) {
                Text("Description")
                    .font(.headline)
                TextField("Optional notes", text: $notes)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
            }
            .padding(.horizontal)

            Spacer()

            // Pay Myself Button
            Button(action: {
                if let amountValue = Double(amount) {
                    appData.addSelfPayment(amount: amountValue, date: date, notes: notes)
                    selectedTab = 0 // Navigate back to Home tab
                }
            }) {
                Text("Pay Myself")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(amount.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(20)
                    .padding(.horizontal)
            }
            .disabled(amount.isEmpty)
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onTapGesture {
            dismissKeyboard() // Dismiss the keyboard on tap
        }
        .navigationBarHidden(true)
    }
    
    // Helper to dismiss the keyboard
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
