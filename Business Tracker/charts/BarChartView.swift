import SwiftUI
import Charts

struct BarChartView: View {
    let data: [PaymentData]

    var body: some View {
        Chart(data) {
            BarMark(
                x: .value("Payment Method", $0.method),
                y: .value("Total Earnings", $0.total)
            )
            .foregroundStyle(by: .value("Method", $0.method))
        }
        .frame(height: 300)
        .padding()
    }
}
