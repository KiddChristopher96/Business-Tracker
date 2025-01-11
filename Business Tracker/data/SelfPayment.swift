import Foundation
import FirebaseFirestore

struct SelfPayment: Identifiable, Codable {
    var id: String? // Firestore document ID
    let amount: Double
    let date: Date
    let notes: String

    // Standard initializer
    init(id: String?, amount: Double, date: Date, notes: String) {
        self.id = id
        self.amount = amount
        self.date = date
        self.notes = notes
    }

    // Initialize from Firestore document snapshot
    init?(from document: DocumentSnapshot) {
        let data = document.data() ?? [:]
        guard let amount = data["amount"] as? Double,
              let timestamp = data["date"] as? Timestamp,
              let notes = data["notes"] as? String else {
            return nil
        }
        self.id = document.documentID
        self.amount = amount
        self.date = timestamp.dateValue()
        self.notes = notes // Correctly assign notes here
    }

    // Convert to Firestore document format
    func toDictionary() -> [String: Any] {
        return [
            "amount": amount,
            "date": Timestamp(date: date),
            "notes": notes
        ]
    }
}

