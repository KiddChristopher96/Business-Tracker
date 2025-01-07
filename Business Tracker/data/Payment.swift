import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable {
    case cash = "Cash"
    case venmo = "Venmo"
    case zelle = "Zelle"
    case jobber = "Jobber"

    var id: String { self.rawValue }
}

struct Payment: Identifiable {
    let id = UUID()
    let amount: Double
    let method: PaymentMethod
    let date: Date
    let notes: String
}

