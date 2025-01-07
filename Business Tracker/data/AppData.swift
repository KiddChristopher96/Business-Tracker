import Foundation

class AppData: ObservableObject {
    @Published var payments: [Payment] = []
    @Published var expenses: [Expense] = []
    @Published var selfPayments: [SelfPayment] = []

    // Computed properties for totals
    var totalEarnings: Double {
        payments.reduce(0) { $0 + $1.amount }
    }

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var totalSelfPayments: Double {
        selfPayments.reduce(0) { $0 + $1.amount }
    }

    var netProfit: Double {
        totalEarnings - totalExpenses - totalSelfPayments
    }

    // Add Payment
    func addPayment(amount: Double, method: PaymentMethod, date: Date, notes: String) {
        payments.append(Payment(amount: amount, method: method, date: date, notes: notes))
    }

    // Add Expense
    func addExpense(amount: Double, date: Date, notes: String) {
        expenses.append(Expense(amount: amount, date: date, notes: notes))
    }

    // Add Self Payment
    func addSelfPayment(amount: Double, date: Date, notes: String) {
        selfPayments.append(SelfPayment(amount: amount, date: date, notes: notes))
    }
}
