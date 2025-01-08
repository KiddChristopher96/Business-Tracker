import SwiftUI

struct ExpenseDetailView: View {
    let expense: Expense
    @EnvironmentObject var appData: AppData
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Expense Details")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Amount: $\(String(format: "%.2f", expense.amount))")
                .font(.title2)

            Text("Date: \(expense.date, style: .date)")
                .font(.title3)

            if !expense.notes.isEmpty {
                Text("Notes: \(expense.notes)")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                Text("Notes: None")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                appData.deleteExpense(expense)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Delete Expense")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Expense Details")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
