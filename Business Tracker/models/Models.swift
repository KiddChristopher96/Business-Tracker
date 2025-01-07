import Foundation
import SwiftUI

struct PaymentData: Identifiable{
    let id = UUID()
    let method: String
    let total: Double
}

