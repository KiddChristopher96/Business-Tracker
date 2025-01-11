import Foundation
import FirebaseFirestore

struct Expense: Identifiable, Codable {
    var id: String?
    let amount: Double
    let date: Date
    let notes: String
    let category: String // Added category property

    init(id: String?, amount: Double, date: Date, notes: String, category: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.notes = notes
        self.category = category
    }

    init?(from document: DocumentSnapshot) {
        let data = document.data() ?? [:]
        guard let amount = data["amount"] as? Double,
              let timestamp = data["date"] as? Timestamp,
              let notes = data["notes"] as? String,
              let category = data["category"] as? String else { // Ensure category is fetched
            return nil
        }
        self.id = document.documentID
        self.amount = amount
        self.date = timestamp.dateValue()
        self.notes = notes
        self.category = category
    }

    func toDictionary() -> [String: Any] {
        return [
            "amount": amount,
            "date": Timestamp(date: date),
            "notes": notes,
            "category": category // Save category
        ]
    }
}
