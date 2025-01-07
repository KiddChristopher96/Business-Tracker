import Foundation

struct SelfPayment: Identifiable{
    let id = UUID()
    let amount: Double
    let date: Date
    let notes: String
}

