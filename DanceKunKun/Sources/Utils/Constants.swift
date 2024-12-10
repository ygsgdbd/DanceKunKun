import Foundation
import SwiftUI

enum Constants {
    enum UI {
        static let minWindowWidth: CGFloat = 200
        static let minWindowHeight: CGFloat = 300
        static let cornerRadius: CGFloat = 12
        static let defaultPadding: CGFloat = 16
    }
    
    enum Animation {
        static let defaultDuration: Double = 0.3
        static let defaultDelay: Double = 0.1
        static let minSpeed: Double = 1.0   // 正常速度
        static let maxSpeed: Double = 2.0
    }
}

extension Color {
    static let appBackground = Color(.windowBackgroundColor)
    static let appForeground = Color(.labelColor)
} 
