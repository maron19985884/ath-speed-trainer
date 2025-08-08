import SwiftUI

struct ModeSelectView: View {
    @Binding var currentScreen: AppScreen
    @Binding var selectedMode: GameMode?

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            Text("Ath Speed Trainer")
                .font(DesignTokens.Typography.title)
                .foregroundColor(DesignTokens.Colors.onDark)
                .padding(.top, DesignTokens.Spacing.xl)

            Text("モード選択")
                .font(DesignTokens.Typography.title)
                .foregroundColor(DesignTokens.Colors.onDark)

            VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                modeButton(title: "タイムアタック", mode: .timeAttack)
                modeButton(title: "10問正解タイムアタック", mode: .correctCount)
                modeButton(title: "ミス耐久", mode: .noMistake)
            }
            .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

            Spacer()

            VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                menuButton(title: "設定", screen: .setting)
                menuButton(title: "クレジット", screen: .credit)
            }
            .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            .padding(.bottom, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
        }
        .background(DesignTokens.Colors.backgroundDark.ignoresSafeArea())
    }

    private func modeButton(title: String, mode: GameMode) -> some View {
        Button(action: {
            selectedMode = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                selectedMode = mode
            }
        }) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .bold()
        }
        .buttonStyle(HologramButtonStyle())
    }

    private func menuButton(title: String, screen: AppScreen) -> some View {
        Button(action: { currentScreen = screen }) {
            Text(title)
                .font(DesignTokens.Typography.body)
                .bold()
        }
        .buttonStyle(HologramButtonStyle())
    }
}

struct HologramButtonStyle: ButtonStyle {
    var isSelected: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let color = isSelected ? DesignTokens.Colors.neonPurple : DesignTokens.Colors.neonBlue
        let radius: CGFloat = (isSelected || configuration.isPressed) ? 12 : 6

        return configuration.label
            .frame(maxWidth: .infinity, minWidth: 120, minHeight: 56)
            .padding(DesignTokens.Spacing.m)
            .background(DesignTokens.Colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.l)
                    .stroke(color.opacity(0.7), lineWidth: 1.5)
            )
            .foregroundColor(DesignTokens.Colors.onDark)
            .cornerRadius(DesignTokens.Radius.l)
            .glow(color, radius: radius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ModeSelectView(currentScreen: .constant(.modeSelect), selectedMode: .constant(nil))
}

