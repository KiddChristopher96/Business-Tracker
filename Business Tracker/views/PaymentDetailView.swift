import SwiftUI

struct PaymentDetailView: View {
    let payment: Payment
    @EnvironmentObject var appData: AppData
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Payment Details")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Amount: $\(String(format: "%.2f", payment.amount))")
                .font(.title2)

            Text("Date: \(payment.date, style: .date)")
                .font(.title3)

            if !payment.notes.isEmpty {
                Text("Notes: \(payment.notes)")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                Text("Notes: None")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                appData.deletePayment(payment)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete Payment")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Payment Details")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
