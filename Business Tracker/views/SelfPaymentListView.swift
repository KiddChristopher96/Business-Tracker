import SwiftUI

struct SelfPaymentListView: View {
    let selfPayments: [SelfPayment]

    var body: some View {
        VStack {
            if selfPayments.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.badge.minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No Self-Payments Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("You haven't recorded any self-payments yet. Start by logging a payment to yourself!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
            } else {
                List(selfPayments) { selfPayment in
                    NavigationLink(destination: SelfPaymentDetailView(selfPayment: selfPayment)) {
                        ActivityCard(
                            title: "Self Payment",
                            amount: selfPayment.amount,
                            date: selfPayment.date,
                            color: .blue
                        )
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle("Paid to Myself")
    }
}
