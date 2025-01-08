import SwiftUI

struct SelfPaymentDetailView: View {
    let selfPayment: SelfPayment
    @EnvironmentObject var appData: AppData
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Self Payment Details")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Amount: $\(String(format: "%.2f", selfPayment.amount))")
                .font(.title2)

            Text("Date: \(selfPayment.date, style: .date)")
                .font(.title3)

            if !selfPayment.notes.isEmpty {
                Text("Notes: \(selfPayment.notes)")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                Text("Notes: None")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                appData.deleteSelfPayment(selfPayment)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete Self Payment")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Self Payment Details")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
