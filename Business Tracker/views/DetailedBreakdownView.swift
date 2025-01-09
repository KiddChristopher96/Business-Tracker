import SwiftUI

struct DetailedBreakdownView: View {
    @EnvironmentObject var appData: AppData

    var body: some View {
        List {
            // Payments Section
            if !appData.payments.isEmpty {
                Section(header: Text("Payments")) {
                    ForEach(appData.payments) { payment in
                        DetailedBreakdownRow(
                            title: "\(payment.method) Payment", // Use method directly as it's now a String
                            amount: payment.amount,
                            date: payment.date,
                            notes: payment.notes,
                            color: .green
                        )
                    }
                }
            }

            // Expenses Section
            if !appData.expenses.isEmpty {
                Section(header: Text("Expenses")) {
                    ForEach(appData.expenses) { expense in
                        DetailedBreakdownRow(
                            title: "Expense",
                            amount: expense.amount,
                            date: expense.date,
                            notes: expense.notes,
                            color: .red
                        )
                    }
                }
            }

            // Self Payments Section
            if !appData.selfPayments.isEmpty {
                Section(header: Text("Paid to Myself")) {
                    ForEach(appData.selfPayments) { selfPayment in
                        DetailedBreakdownRow(
                            title: "Paid to Myself",
                            amount: selfPayment.amount,
                            date: selfPayment.date,
                            notes: selfPayment.notes,
                            color: .blue
                        )
                    }
                }
            }
        }
        .navigationTitle("Detailed Breakdown")
    }
}

