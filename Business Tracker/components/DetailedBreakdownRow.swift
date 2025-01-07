import SwiftUI

struct DetailedBreakdownRow: View {
    let title: String
    let amount: Double
    let date: Date
    let notes: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(title)
                    .font(.headline)
            }

            Text("Amount: $\(String(format: "%.2f", amount))")
                .font(.subheadline)

            Text("Date: \(date, style: .date)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if !notes.isEmpty {
                Text("Notes: \(notes)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

