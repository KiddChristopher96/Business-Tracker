import SwiftUI
import FirebaseAuth
import UniformTypeIdentifiers

struct HamburgerMenu: View {
    @Binding var isOpen: Bool
    @EnvironmentObject var appData: AppData
    @State private var showLogoutConfirmation = false // State for logout confirmation dialog
    @State private var showExportDialog = false // State for showing export dialog

    var body: some View {
        ZStack {
            // Dimmed background
            if isOpen {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isOpen = false
                        }
                    }
            }

            // Full-Screen Menu Content
            VStack(alignment: .leading, spacing: 0) {
                // Header Section
                HStack {
                    Button(action: {
                        withAnimation {
                            isOpen = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.horizontal)

                // Menu Sections
                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
                        // Section 1: Business Management
                        SectionHeader(title: "Manage Your Business")
                        MenuItem(icon: "dollarsign.circle", title: "Payments") {
                            print("Payments tapped")
                        }
                        MenuItem(icon: "cart", title: "Expenses") {
                            print("Expenses tapped")
                        }
                        MenuItem(icon: "chart.bar", title: "Analytics") {
                            print("Analytics tapped")
                        }

                        // Section 2: Settings
                        SectionHeader(title: "Settings")
                        MenuItem(icon: "gearshape", title: "General Settings") {
                            print("General Settings tapped")
                        }
                        MenuItem(icon: "bell", title: "Notifications") {
                            print("Notifications tapped")
                        }

                        // Section 3: Support
                        SectionHeader(title: "Support")
                        MenuItem(icon: "questionmark.circle", title: "Help & Support") {
                            print("Help & Support tapped")
                        }

                        // Export Data
                        MenuItem(icon: "doc.text", title: "Export Data") {
                            showExportDialog.toggle()
                        }

                        // Logout
                        Divider()
                        MenuItem(icon: "arrow.backward.circle", title: "Logout") {
                            showLogoutConfirmation.toggle() // Show confirmation dialog
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // Bottom Placeholder: App Info
                VStack {
                    Divider()
                    Text("App version 1.0")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.vertical)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .offset(x: isOpen ? 0 : UIScreen.main.bounds.width) // Full-screen slide-in effect
            .animation(.easeInOut, value: isOpen)
        }
        .confirmationDialog(
            "Are you sure you want to logout?",
            isPresented: $showLogoutConfirmation,
            titleVisibility: .visible
        ) {
            Button("Logout", role: .destructive, action: handleLogout)
            Button("Cancel", role: .cancel, action: {})
        }
        .sheet(isPresented: $showExportDialog) {
            ExportDataView(showExportDialog: $showExportDialog)
                .environmentObject(appData) // Inject EnvironmentObject here
        }
    }

    private func handleLogout() {
        // Perform the logout logic
        do {
            try Auth.auth().signOut() // Firebase logout
            withAnimation {
                isOpen = false
            }
            // Navigate to LoginView
            (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
                .windows.first(where: \.isKeyWindow)?.rootViewController = UIHostingController(rootView: LoginView())
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// MARK: - Export Options Enum
enum ExportOption: String, CaseIterable {
    case all = "All Data"
    case payments = "Payments"
    case expenses = "Expenses"
    case selfPayments = "Self Payments"
}

// MARK: - Export Data View
struct ExportDataView: View {
    @Binding var showExportDialog: Bool
    @EnvironmentObject var appData: AppData
    @State private var selectedOption: ExportOption = .all
    @State private var fileContent: String? // Holds CSV content for saving
    @State private var showSavePicker = false // To display save location picker
    @State private var showExportConfirmation = false // For export confirmation

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Export Data")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Picker("Select Export Option", selection: $selectedOption) {
                    ForEach(ExportOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button(action: exportData) {
                    Text("Export \(selectedOption.rawValue)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationBarTitle("Export Data", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                showExportDialog = false
            })
            .alert("Export Successful", isPresented: $showExportConfirmation) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your data has been successfully exported.")
            }
            .fileExporter(isPresented: $showSavePicker, document: CSVDocument(csvString: fileContent ?? ""), contentType: .plainText, defaultFilename: "ExportedData.csv") { result in
                switch result {
                case .success:
                    showExportConfirmation = true
                case .failure(let error):
                    print("Error saving file: \(error.localizedDescription)")
                }
            }
        }
    }

    private func exportData() {
        switch selectedOption {
        case .all:
            exportAllDataAsCSV()
        case .payments:
            exportPaymentsAsCSV()
        case .expenses:
            exportExpensesAsCSV()
        case .selfPayments:
            exportSelfPaymentsAsCSV()
        }
    }

    private func exportAllDataAsCSV() {
        let allData = appData.payments.map { $0.toTransaction() } +
                      appData.expenses.map { $0.toTransaction() } +
                      appData.selfPayments.map { $0.toTransaction() }
        prepareCSV(data: allData)
    }

    private func exportPaymentsAsCSV() {
        let payments = appData.payments.map { $0.toTransaction() }
        prepareCSV(data: payments)
    }

    private func exportExpensesAsCSV() {
        let expenses = appData.expenses.map { $0.toTransaction() }
        prepareCSV(data: expenses)
    }

    private func exportSelfPaymentsAsCSV() {
        let selfPayments = appData.selfPayments.map { $0.toTransaction() }
        prepareCSV(data: selfPayments)
    }

    private func prepareCSV(data: [Transaction]) {
        let csvHeader = "Description,Amount,Date\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        let csvRows = data.map { transaction -> String in
            let formattedDate = dateFormatter.string(from: transaction.date)
            return "\(transaction.description),\(transaction.amount),\(formattedDate)"
        }.joined(separator: "\n")

        fileContent = csvHeader + csvRows
        showSavePicker = true
    }
}

// MARK: - CSV Document for Exporting
struct CSVDocument: FileDocument {
    var csvString: String

    static var readableContentTypes: [UTType] { [.plainText] }

    init(csvString: String) {
        self.csvString = csvString
    }

    init(configuration: ReadConfiguration) throws {
        self.csvString = ""
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = csvString.data(using: .utf8)!
        return FileWrapper(regularFileWithContents: data)
    }
}

// MARK: - Helper Components
struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.bold)
            .padding(.top, 10)
            .padding(.bottom, 5)
    }
}

struct MenuItem: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
