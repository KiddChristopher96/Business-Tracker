import SwiftUI

struct ExpenseListView: View {
    let expenses: [Expense]

    var body: some View {
        VStack {
            Text("Expenses")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            if expenses.isEmpty {
                Text("No expenses data available.")
                    .foregroundColor(.gray)
            } else {
                List(expenses) { expense in
                    NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                        ActivityCard(
                            title: "Expense",
                            amount: expense.amount,
                            date: expense.date,
                            color: .red
                        )
                    }
                }
            }
        }
        .navigationTitle("Expenses")
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}
