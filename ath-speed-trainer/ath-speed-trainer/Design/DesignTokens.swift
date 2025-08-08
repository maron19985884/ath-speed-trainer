import SwiftUI

enum DesignTokens {
    enum Colors {
        static let backgroundDark = Color(hex: "#0A0A0F")
        static let surface = Color(hex: "#101018")
        static let neonBlue = Color(hex: "#00E5FF")
        static let neonBlueDeep = Color(hex: "#007ACC")
        static let neonPurple = Color(hex: "#A020F0")
        static let neonGreen = Color(hex: "#39FF14")   // 正解
        static let neonRed = Color(hex: "#FF073A")     // 不正解
        static let onDark = Color.white.opacity(0.92)
        static let onMuted = Color.white.opacity(0.7)
    }

    enum Typography {
        static let digitalMono = Font.system(.largeTitle, design: .monospaced)
        static let title = Font.system(size: 28, weight: .bold)
        static let body = Font.system(size: 17, weight: .regular)
    }

    enum Spacing {
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 16
        static let xl: CGFloat = 24
    }

    enum Radius {
        static let m: CGFloat = 12
        static let l: CGFloat = 16
    }

    enum Elevation {
        static let keycapShadowColor = Colors.neonBlue.opacity(0.25)
        static let keycapShadowRadius: CGFloat = 8
        static let keycapShadowY: CGFloat = 2
    }
}

extension View {
    func glow(_ color: Color, radius: CGFloat = 12) -> some View {
        self
            .shadow(color: color.opacity(0.8), radius: radius)
            .shadow(color: color.opacity(0.5), radius: radius / 2)
    }

    func keycapShadow() -> some View {
        self.shadow(
            color: DesignTokens.Elevation.keycapShadowColor,
            radius: DesignTokens.Elevation.keycapShadowRadius,
            y: DesignTokens.Elevation.keycapShadowY
        )
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}

