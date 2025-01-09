import SwiftUI

struct PaymentListView: View {
    let payments: [Payment]

    var body: some View {
        VStack {
            if payments.isEmpty {
                // Empty State
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No Earnings Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("You haven't recorded any earnings yet. Add your first payment to get started!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
            } else {
                // List of Payments
                List(payments) { payment in
                    NavigationLink(destination: PaymentDetailView(payment: payment)) {
                        ActivityCard(
                            title: payment.method, // Updated to dynamic method (String)
                            amount: payment.amount,
                            date: payment.date,
                            color: .green // Keep consistent color for earnings
                        )
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle("Earnings")
    }
}
