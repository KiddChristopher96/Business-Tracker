import SwiftUI

struct PaymentListView: View {
    let payments: [Payment]
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body: some View {
        VStack(spacing: 20) {
            // Custom Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                }
                Spacer()
                Text("Earnings")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary) // Adapts to light/dark mode
                Spacer()
                Spacer() // For alignment
            }
            .padding(.horizontal)
            .padding(.top)

            if payments.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "tray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.5))

                    Text("No Earnings Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("You haven't recorded any earnings yet. Add your first payment to get started!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea()) // Adaptive background
            } else {
                // Payments List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(payments) { payment in
                            PaymentCard(payment: payment)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 16)
                    .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea()) // Adaptive background
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea()) // Adaptive background
        .navigationBarHidden(true) // Hides the default navigation bar
    }
}

// MARK: - Payment Card
struct PaymentCard: View {
    let payment: Payment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Payment Method and Date
            HStack {
                Text(payment.method)
                    .font(.headline)
                    .foregroundColor(.green) // Matches earnings theme
                Spacer()
                Text(payment.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Amount
            Text("$\(String(format: "%.2f", payment.amount))")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            // Notes (if any)
            if !payment.notes.isEmpty {
                Text(payment.notes)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }

            // View Button
            HStack {
                Spacer()
                NavigationLink(destination: PaymentDetailView(payment: payment)) {
                    Text("View Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.green.opacity(0.1))
                        .foregroundColor(.green)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground)) // Adaptive card background
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
    }
}
