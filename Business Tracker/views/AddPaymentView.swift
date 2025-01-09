import SwiftUI

struct AddPaymentView: View {
    @EnvironmentObject var appData: AppData
    @State private var amount: String = ""
    @State private var selectedMethod: String = "Cash"
    @State private var methods: [String] = ["Cash", "Venmo", "Zelle", "Jobber"]
    @State private var newMethod: String = ""
    @State private var showNewMethodField: Bool = false
    @State private var date = Date()
    @State private var notes: String = ""
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("New Payment")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()

            // Amount Input
            HStack {
                Spacer()
                TextField("0", text: $amount)
                    .font(.system(size: 48, weight: .bold))
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .foregroundColor(.primary)
                Text("$")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)

            // Payment Method Picker
            VStack(alignment: .leading, spacing: 15) {
                Text("Payment Method")
                    .font(.headline)

                HStack(spacing: 10) {
                    // Dropdown for existing methods
                    Menu {
                        ForEach(methods, id: \.self) { method in
                            Button(action: {
                                selectedMethod = method
                            }) {
                                Text(method)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedMethod.isEmpty ? "Select Method" : selectedMethod)
                                .foregroundColor(selectedMethod.isEmpty ? .gray : .primary)
                                .font(.body)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    }

                    // Button to add a new method
                    Button(action: {
                        showNewMethodField.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                    }
                }

                // Field for adding a new method
                if showNewMethodField {
                    HStack {
                        TextField("Enter New Method", text: $newMethod)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(20)

                        Button(action: addNewMethod) {
                            Text("Save")
                                .fontWeight(.bold)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color.green.opacity(0.2))
                                .foregroundColor(.green)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .padding(.horizontal)

            // Date Picker
            HStack {
                Text("Date")
                    .font(.headline)
                Spacer()
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)

            // Notes Input
            VStack(alignment: .leading, spacing: 15) {
                Text("Description")
                    .font(.headline)
                TextField("Optional notes", text: $notes)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
            }
            .padding(.horizontal)

            Spacer()

            // Add Payment Button
            Button(action: addPayment) {
                Text("Add Payment")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(amount.isEmpty || selectedMethod.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(20)
                    .padding(.horizontal)
            }
            .disabled(amount.isEmpty || selectedMethod.isEmpty)
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // Add new method function
    private func addNewMethod() {
        guard !newMethod.isEmpty else { return }
        if !methods.contains(newMethod) {
            methods.append(newMethod)
            selectedMethod = newMethod
        }
        newMethod = ""
        showNewMethodField = false
    }

    // Add payment function
    private func addPayment() {
        if let amountValue = Double(amount) {
            appData.addPayment(amount: amountValue, method: selectedMethod, date: date, notes: notes)
            selectedTab = 0 // Navigate back to Home tab
        }
    }
}
