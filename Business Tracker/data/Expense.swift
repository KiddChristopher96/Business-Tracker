import Foundation

struct Expense: Identifiable {
    let id = UUID()
    let amount: Double
    let date: Date
    let notes: String
}
