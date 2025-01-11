import SwiftUI

struct PaymentDetailView: View {
    let payment: Payment
    @EnvironmentObject var appData: AppData
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            // Custom Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Go back to PaymentListView
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                }
                Spacer()
                Text("Payment Details")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary) // Adapts to light/dark mode
                Spacer()
                Spacer() // For alignment
            }
            .padding(.horizontal)
            .padding(.top)

            // Payment Details Section
            VStack(spacing: 20) {
                // Amount
                HStack {
                    Text("Amount")
                        .font(.headline)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                    Spacer()
                    Text("$\(String(format: "%.2f", payment.amount))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                }
                .padding(.bottom, 10)
                .overlay(Divider().background(Color(.separator)), alignment: .bottom) // Separator adapts

                // Date
                HStack {
                    Text("Date")
                        .font(.headline)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                    Spacer()
                    Text("\(payment.date, style: .date)")
                        .font(.body)
                        .foregroundColor(.secondary) // Adapts to light/dark mode
                }
                .padding(.bottom, 10)
                .overlay(Divider().background(Color(.separator)), alignment: .bottom)

                // Method
                HStack {
                    Text("Method")
                        .font(.headline)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                    Spacer()
                    Text(payment.method)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .padding(.bottom, 10)
                .overlay(Divider().background(Color(.separator)), alignment: .bottom)

                // Notes
                HStack(alignment: .top) {
                    Text("Notes")
                        .font(.headline)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                    Spacer()
                    if !payment.notes.isEmpty {
                        Text(payment.notes)
                            .font(.body)
                            .foregroundColor(.secondary) // Adapts to light/dark mode
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                    } else {
                        Text("None")
                            .font(.body)
                            .foregroundColor(.secondary) // Adapts to light/dark mode
                    }
                }
                .padding(.bottom, 10)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground)) // Adapts to light/dark mode
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
            .padding(.horizontal)

            Spacer()

            // Delete Payment Button
            Button(action: {
                appData.deletePayment(payment)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal)
            .padding(.bottom, 20) // Add padding to the bottom for spacing from the tab bar
        }
        .padding(.top)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea()) // Adapts to light/dark mode
        .navigationBarHidden(true) // Hide default navigation bar
    }
}
