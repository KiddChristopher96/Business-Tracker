import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AppData: ObservableObject {
    @Published var payments: [Payment] = []
    @Published var expenses: [Expense] = []
    @Published var selfPayments: [SelfPayment] = []

    private let db = Firestore.firestore()
    private var authStateListener: AuthStateDidChangeListenerHandle?

    init() {
        // Observe authentication state changes
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                print("User logged in: \(user.uid)")
                self.fetchPayments()
                self.fetchExpenses()
                self.fetchSelfPayments()
            } else {
                print("User signed out")
                self.clearData()
            }
        }
    }

    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }

    // MARK: - Clear Data on Logout
    private func clearData() {
        payments = []
        expenses = []
        selfPayments = []
    }

    // MARK: - Computed Properties for Totals
    var totalEarnings: Double {
        payments.reduce(0) { $0 + $1.amount }
    }

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    var netProfit: Double {
        totalEarnings - totalExpenses - selfPayments.reduce(0) { $0 + $1.amount }
    }

    // MARK: - Payments
    func addPayment(amount: Double, method: String, date: Date, notes: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let payment = Payment(id: nil, amount: amount, method: method, date: date, notes: notes)
        db.collection("users").document(userID).collection("payments").addDocument(data: payment.toDictionary())
    }

    func fetchPayments() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("payments").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching payments: \(error)")
                return
            }
            self.payments = querySnapshot?.documents.compactMap { Payment(from: $0) } ?? []
        }
    }

    func deletePayment(_ payment: Payment) {
        guard let userID = Auth.auth().currentUser?.uid, let paymentID = payment.id else { return }
        db.collection("users").document(userID).collection("payments").document(paymentID).delete()
    }

    // MARK: - Expenses
    func addExpense(amount: Double, date: Date, notes: String, category: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let expense = Expense(id: nil, amount: amount, date: date, notes: notes, category: category)
        db.collection("users").document(userID).collection("expenses").addDocument(data: expense.toDictionary()) { error in
            if let error = error {
                print("Error adding expense: \(error)")
            }
        }
    }

    func fetchExpenses() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("expenses").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching expenses: \(error)")
                return
            }
            self.expenses = querySnapshot?.documents.compactMap { Expense(from: $0) } ?? []
            print("Expenses updated: \(self.expenses.count) records")
        }
    }

    func deleteExpense(_ expense: Expense) {
        guard let userID = Auth.auth().currentUser?.uid, let expenseID = expense.id else { return }
        db.collection("users").document(userID).collection("expenses").document(expenseID).delete { error in
            if let error = error {
                print("Error deleting expense: \(error)")
            } else {
                self.expenses.removeAll { $0.id == expense.id }
            }
        }
    }

    // MARK: - Self Payments
    func addSelfPayment(amount: Double, date: Date, notes: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let selfPayment = SelfPayment(id: nil, amount: amount, date: date, notes: notes)
        db.collection("users").document(userID).collection("selfPayments").addDocument(data: selfPayment.toDictionary()) { error in
            if let error = error {
                print("Error adding self payment: \(error)")
            }
        }
    }

    func fetchSelfPayments() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userID).collection("selfPayments").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching self payments: \(error)")
                return
            }
            self.selfPayments = querySnapshot?.documents.compactMap { SelfPayment(from: $0) } ?? []
            print("Self payments updated: \(self.selfPayments.count) records")
        }
    }

    func deleteSelfPayment(_ selfPayment: SelfPayment) {
        guard let userID = Auth.auth().currentUser?.uid, let selfPaymentID = selfPayment.id else { return }
        db.collection("users").document(userID).collection("selfPayments").document(selfPaymentID).delete { error in
            if let error = error {
                print("Error deleting self-payment: \(error)")
            } else {
                self.selfPayments.removeAll { $0.id == selfPayment.id }
            }
        }
    }

    // MARK: - General Settings
    func saveSettings(profileName: String, businessName: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        let settingsData: [String: Any] = [
            "profileName": profileName,
            "businessName": businessName,
            "email": email,
            "updatedAt": Timestamp()
        ]

        db.collection("users").document(userID).setData(settingsData, merge: true) { error in
            if let error = error {
                print("Error saving settings: \(error)")
                completion(.failure(error))
            } else {
                print("Settings saved successfully")
                completion(.success(()))
            }
        }
    }

    func fetchSettings(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }

        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching settings: \(error)")
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document.data() ?? [:]))
            } else {
                completion(.failure(NSError(domain: "FirestoreError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Settings not found"])))
            }
        }
    }
}
