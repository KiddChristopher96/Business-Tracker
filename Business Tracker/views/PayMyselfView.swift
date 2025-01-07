import SwiftUI

struct PayMyselfView: View {
    @EnvironmentObject var appData: AppData
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var notes: String = ""

    @Binding var selectedTab: Int // Binding to control the selected tab

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Pay Myself")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Input Fields in Cards
                VStack(spacing: 15) {
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
                    .shadow(radius: 2)

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
                    .shadow(radius: 2)

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
                    .shadow(radius: 2)
                }
                .padding()

                // Pay Myself Button
                Button(action: {
                    if let amountValue = Double(amount) {
                        appData.addSelfPayment(amount: amountValue, date: date, notes: notes)
                        selectedTab = 0 // Navigate back to Home tab
                    }
                }) {
                    Text("Pay Myself")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .navigationTitle("")
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
            .onAppear {
                // Reset the form fields
                amount = ""
                date = Date()
                notes = ""
            }
        }
    }
}
