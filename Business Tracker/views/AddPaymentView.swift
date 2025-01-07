import SwiftUI

struct AddPaymentView: View {
    @EnvironmentObject var appData: AppData
    @State private var amount: String = "" // TextField input is a String
    @State private var selectedMethod: PaymentMethod = .cash
    @State private var date = Date()
    @State private var notes: String = ""

    @Binding var selectedTab: Int // Binding to control the active tab

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Add Payment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Input Fields
                VStack(spacing: 15) {
                    // Amount Input
                    HStack {
                        Text("Amount")
                            .font(.headline)
                        Spacer()
                        TextField("Enter amount", text: $amount)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    // Payment Method Picker
                    HStack {
                        Text("Payment Method")
                            .font(.headline)
                        Spacer()
                        Picker("Method", selection: $selectedMethod) {
                            ForEach(PaymentMethod.allCases) { method in
                                Text(method.rawValue).tag(method)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

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
                    .cornerRadius(12)

                    // Notes Input
                    HStack {
                        Text("Notes")
                            .font(.headline)
                        Spacer()
                        TextField("Optional notes", text: $notes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding()

                // Add Payment Button
                Button(action: {
                    if let amountValue = Double(amount) { // Convert String to Double
                        appData.addPayment(amount: amountValue, method: selectedMethod, date: date, notes: notes)
                        selectedTab = 0 // Navigate back to Home tab
                    }
                }) {
                    Text("Add Payment")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("Add Payment")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selectedTab = 0 // Navigate back to Home tab
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }
}
