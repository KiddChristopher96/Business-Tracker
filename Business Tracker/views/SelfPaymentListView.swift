import SwiftUI

struct SelfPaymentListView: View {
    let selfPayments: [SelfPayment]

    var body: some View {
        VStack {
            Text("Paid to Myself")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if selfPayments.isEmpty {
                Text("No self-payments data available.")
                    .foregroundColor(.gray)
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
            }
        }
        .navigationTitle("Paid to Myself")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
