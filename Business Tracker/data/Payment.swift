// Payment Model
import Foundation
import FirebaseFirestore

enum PaymentMethod: String, CaseIterable, Identifiable {
    case cash = "Cash"
    case venmo = "Venmo"
    case zelle = "Zelle"
    case jobber = "Jobber"

    var id: String { self.rawValue }
}

struct Payment: Identifiable {
    var id: String?
    var amount: Double
    var method: PaymentMethod
    var date: Date
    var notes: String

    init(id: String?, amount: Double, method: PaymentMethod, date: Date, notes: String) {
        self.id = id
        self.amount = amount
        self.method = method
        self.date = date
        self.notes = notes
    }

    init?(from document: DocumentSnapshot) {
        let data = document.data() ?? [:]
        guard let amount = data["amount"] as? Double,
              let methodString = data["method"] as? String,
              let method = PaymentMethod(rawValue: methodString),
              let timestamp = data["date"] as? Timestamp,
              let notes = data["notes"] as? String else {
            return nil
        }
        self.id = document.documentID
        self.amount = amount
        self.method = method
        self.date = timestamp.dateValue()
        self.notes = notes
    }

    func toDictionary() -> [String: Any] {
        return [
            "amount": amount,
            "method": method.rawValue,
            "date": Timestamp(date: date),
            "notes": notes
        ]
    }
}
