import SwiftUI

struct SelfPaymentListView: View {
    let selfPayments: [SelfPayment]
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary) // Adapts to light/dark mode
                }
                Spacer()
                Text("Paid to Myself")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary) // Adapts to light/dark mode
                Spacer()
                Spacer() // For alignment
            }
            .padding(.horizontal)
            .padding(.top)

            if selfPayments.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.badge.minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.5))

                    Text("No Self-Payments Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("You haven't recorded any self-payments yet. Start by logging a payment to yourself!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea()) // Adaptive background
            } else {
                // Self-Payments List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(selfPayments) { selfPayment in
                            SelfPaymentCard(selfPayment: selfPayment)
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

struct SelfPaymentCard: View {
    let selfPayment: SelfPayment

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Description and Date
            HStack {
                Text("Self Payment")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text(selfPayment.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Amount
            Text("$\(String(format: "%.2f", selfPayment.amount))")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            // Notes (if any)
            if !selfPayment.notes.isEmpty {
                Text(selfPayment.notes)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }

            // View Button
            HStack {
                Spacer()
                NavigationLink(destination: SelfPaymentDetailView(selfPayment: selfPayment)) {
                    Text("View Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
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
