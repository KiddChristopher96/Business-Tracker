import Foundation
import FirebaseFirestore

enum PaymentMethod: Identifiable , Codable{
    case predefined(String)
    case custom(String)

    static var predefinedMethods: [PaymentMethod] {
        [.predefined("Cash"), .predefined("Venmo"), .predefined("Zelle"), .predefined("Jobber")]
    }

    var rawValue: String {
        switch self {
        case .predefined(let method), .custom(let method):
            return method
        }
    }

    var id: String { rawValue }
}

struct Payment: Identifiable, Codable {
    var id: String?
    let amount: Double
    let method: String
    let date: Date
    let notes: String

    init(id: String?, amount: Double, method: String, date: Date, notes: String) {
        self.id = id
        self.amount = amount
        self.method = method
        self.date = date
        self.notes = notes
    }

    init?(from document: DocumentSnapshot) {
        let data = document.data() ?? [:]
        guard let amount = data["amount"] as? Double,
              let method = data["method"] as? String,
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
            "method": method,
            "date": Timestamp(date: date),
            "notes": notes
        ]
    }
}
