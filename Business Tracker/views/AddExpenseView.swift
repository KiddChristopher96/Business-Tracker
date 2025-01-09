import SwiftUI

struct AddExpenseView: View {
    @EnvironmentObject var appData: AppData
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var notes: String = ""
    @State private var selectedCategory: String = ""
    @State private var categories: [String] = ["Food", "Travel", "Utilities", "Other"]
    @State private var newCategory: String = ""
    @State private var showNewCategoryField: Bool = false
    @State private var isRecurring: Bool = false
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    selectedTab = 0 // Navigate back to Home tab
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("New Expense")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()

            // Amount Input
            HStack {
                Spacer()
                TextField("0", text: $amount)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .foregroundColor(.primary)
                Text("$")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)

            // Date Picker
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.primary)
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

            // Category Picker
            VStack(alignment: .leading, spacing: 15) {
                Text("Category")
                    .font(.headline)

                HStack(spacing: 10) {
                    // Category Dropdown Menu
                    Menu {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedCategory.isEmpty ? "Select Category" : selectedCategory)
                                .foregroundColor(selectedCategory.isEmpty ? .gray : .primary)
                                .font(.body)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    }

                    // Add New Category Button
                    Button(action: {
                        showNewCategoryField.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(Color.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(20)
                    }
                }

                // New Category TextField (Only visible when button is tapped)
                if showNewCategoryField {
                    HStack {
                        TextField("Enter New Category", text: $newCategory)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(20)

                        Button(action: {
                            addNewCategory()
                        }) {
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

            // Recurring Toggle
            HStack {
                Image(systemName: "repeat")
                VStack(alignment: .leading) {
                    Text("Add as recurring")
                        .font(.headline)
                    Text("This expense will be added again automatically on the same date each month.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Toggle("", isOn: $isRecurring)
                    .labelsHidden()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .padding(.horizontal)

            Spacer()

            // Add Expense Button
            Button(action: {
                if let amountValue = Double(amount), !selectedCategory.isEmpty {
                    appData.addExpense(amount: amountValue, date: date, notes: notes, category: selectedCategory)
                    if isRecurring {
                        // Logic to handle recurring expense
                    }
                    selectedTab = 0 // Navigate back to Home tab
                }
            }) {
                Text("Add Expense")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(amount.isEmpty || selectedCategory.isEmpty ? Color.gray : Color.red)
                    .cornerRadius(20)
                    .padding(.horizontal)
            }
            .disabled(amount.isEmpty || selectedCategory.isEmpty)
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // Function to add a new category
    private func addNewCategory() {
        guard !newCategory.isEmpty else { return }
        if !categories.contains(newCategory) {
            categories.append(newCategory)
            selectedCategory = newCategory
        }
        newCategory = ""
        showNewCategoryField = false
    }
}
