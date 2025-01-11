import SwiftUI

struct ExpenseListView: View {
    let expenses: [Expense]
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
                Text("Expenses")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary) // Adapts to light/dark mode
                Spacer()
                Spacer() // For alignment
            }
            .padding(.horizontal)
            .padding(.top)

            if expenses.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Image(systemName: "cart.badge.minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.5))

                    Text("No Expenses Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text("You haven't recorded any expenses yet. Add your first expense to keep track of your spending!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea()) // Adaptive background
            } else {
                // Expenses List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(expenses) { expense in
                            ExpenseCard(expense: expense)
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

struct ExpenseCard: View {
    let expense: Expense

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category and Date
            HStack {
                Text(expense.category)
                    .font(.headline)
                    .foregroundColor(.red) // Updated to red for expenses
                Spacer()
                Text(expense.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Amount
            Text("$\(String(format: "%.2f", expense.amount))")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            // Notes (if any)
            if !expense.notes.isEmpty {
                Text(expense.notes)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }

            // View Button
            HStack {
                Spacer()
                NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                    Text("View Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.red.opacity(0.1)) // Updated background to red
                        .foregroundColor(.red) // Updated text color to red
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
