import SwiftUI

struct PaymentListView: View {
    let payments: [Payment]

    var body: some View {
        VStack {
            Text("Earnings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if payments.isEmpty {
                Text("No earnings data available.")
                    .foregroundColor(.gray)
            } else {
                List(payments) { payment in
                    NavigationLink(destination: PaymentDetailView(payment: payment)) {
                        ActivityCard(
                            title: payment.method.rawValue,
                            amount: payment.amount,
                            date: payment.date,
                            color: .green
                        )
                    }
                }
            }
        }
        .navigationTitle("Earnings")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
