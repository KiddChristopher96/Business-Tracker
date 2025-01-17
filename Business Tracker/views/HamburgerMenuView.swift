import SwiftUI
import FirebaseAuth
import UniformTypeIdentifiers

struct HamburgerMenu: View {
    @Binding var isOpen: Bool
    @EnvironmentObject var appData: AppData
    @State private var showLogoutConfirmation = false
    @State private var showExportDialog = false

    var body: some View {
        ZStack {
            if isOpen {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isOpen = false
                        }
                    }
            }

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation {
                            isOpen = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 30) {
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

                        SectionHeader(title: "Settings")
                        MenuItem(icon: "gearshape", title: "General Settings") {
                            print("General Settings tapped")
                        }
                        MenuItem(icon: "bell", title: "Notifications") {
                            print("Notifications tapped")
                        }

                        SectionHeader(title: "Support")
                        MenuItem(icon: "questionmark.circle", title: "Help & Support") {
                            print("Help & Support tapped")
                        }

                        MenuItem(icon: "doc.text", title: "Export Data") {
                            showExportDialog.toggle()
                        }

                        Divider()
                        MenuItem(icon: "arrow.backward.circle", title: "Logout") {
                            showLogoutConfirmation.toggle()
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                }

                Spacer()

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
            .offset(x: isOpen ? 0 : UIScreen.main.bounds.width)
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
                .environmentObject(appData)
        }
    }

    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            withAnimation {
                isOpen = false
            }
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
    @State private var customFileName: String = ""
    @State private var preparedData: [Transaction] = []
    @State private var exportURL: URL?
    @State private var showShareSheet = false

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { showExportDialog = false }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("Export Data")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()

            Text("Select Data to Export")
                .font(.headline)
                .padding(.top)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(ExportOption.allCases, id: \.self) { option in
                    VStack {
                        Image(systemName: iconFor(option: option))
                            .font(.largeTitle)
                            .foregroundColor(colorFor(option: option))
                        Text(option.rawValue)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(colorFor(option: option))
                    }
                    .padding()
                    .frame(width: 140, height: 140)
                    .background(selectedOption == option ? colorFor(option: option).opacity(0.2) : Color(.systemGray6))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .onTapGesture {
                        selectedOption = option
                        prepareExportData()
                    }
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 10) {
                Text("File Name")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.leading)

                TextField("Enter File Name", text: $customFileName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()

            Button(action: exportData) {
                Text("Export \(selectedOption.rawValue)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(colorFor(option: selectedOption))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .opacity(customFileName.isEmpty ? 0.6 : 1.0)
            }
            .disabled(customFileName.isEmpty)
            .sheet(isPresented: $showShareSheet) {
                if let exportURL = exportURL {
                    ShareSheet(activityItems: [exportURL])
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear(perform: prepareExportData)
    }

    private func prepareExportData() {
        // Only prepare data, do not generate a file
        switch selectedOption {
        case .all:
            preparedData = appData.payments.map { $0.toTransaction() } +
                           appData.expenses.map { $0.toTransaction() } +
                           appData.selfPayments.map { $0.toTransaction() }
        case .payments:
            preparedData = appData.payments.map { $0.toTransaction() }
        case .expenses:
            preparedData = appData.expenses.map { $0.toTransaction() }
        case .selfPayments:
            preparedData = appData.selfPayments.map { $0.toTransaction() }
        }
    }

    private func exportData() {
        guard !customFileName.isEmpty else { return }
        generateCSV(data: preparedData)
    }

    private func generateCSV(data: [Transaction]) {
        let csvHeader = "Description,Amount,Date\n"
        let csvRows = data.map { "\($0.description),\($0.amount),\($0.date)" }.joined(separator: "\n")
        let csvContent = csvHeader + csvRows

        let fileName = customFileName.hasSuffix(".csv") ? customFileName : "\(customFileName).csv"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try csvContent.write(to: tempURL, atomically: true, encoding: .utf8)
            print("File saved at: \(tempURL)") // Debug log
            exportURL = tempURL
            showShareSheet = true
        } catch {
            print("Failed to save file: \(error.localizedDescription)")
        }
    }

    private func iconFor(option: ExportOption) -> String {
        switch option {
        case .all: return "tray.full"
        case .payments: return "dollarsign.circle"
        case .expenses: return "cart"
        case .selfPayments: return "person.crop.circle"
        }
    }

    private func colorFor(option: ExportOption) -> Color {
        switch option {
        case .all: return .blue
        case .payments: return .green
        case .expenses: return .red
        case .selfPayments: return .cyan
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
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
