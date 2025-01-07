import SwiftUI
import Charts

struct LineChartView: View {
    let data: [EarningsOverTime]

    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("Date", $0.date),
                y: .value("Total Earnings", $0.amount)
            )
        }
        .frame(height: 300)
        .padding()
    }
}

