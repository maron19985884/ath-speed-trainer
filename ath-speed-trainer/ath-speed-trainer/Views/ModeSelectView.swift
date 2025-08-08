import SwiftUI

struct ModeSelectView: View {
    @Binding var currentScreen: AppScreen
    @Binding var selectedMode: GameMode?

    var body: some View {
        VStack {
            Text("Ath Speed Trainer")
                .font(DesignTokens.Typography.title)
                .padding(.top, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

            Text("モード選択")
                .font(DesignTokens.Typography.body)
                .padding(.top, DesignTokens.Spacing.s)

            VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                modeButton(title: "タイムアタック", mode: .timeAttack)
                modeButton(title: "10問正解タイムアタック", mode: .correctCount)
                modeButton(title: "ミス耐久", mode: .noMistake)
            }
            .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            .padding(.top, DesignTokens.Spacing.l)

            Spacer()

            VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                menuButton(title: "設定", screen: .setting)
                menuButton(title: "クレジット", screen: .credit)
            }
            .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            .padding(.bottom, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
        }
        .foregroundColor(DesignTokens.Colors.onDark)
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
                .frame(maxWidth: .infinity)
                .padding(DesignTokens.Spacing.m)
                .background(DesignTokens.Colors.neonBlue.opacity(0.2))
                .cornerRadius(DesignTokens.Radius.m)
                .foregroundColor(DesignTokens.Colors.onDark)
        }
        .contentShape(Rectangle())
    }

    private func menuButton(title: String, screen: AppScreen) -> some View {
        Button(action: { currentScreen = screen }) {
            Text(title)
                .font(DesignTokens.Typography.body)
                .frame(maxWidth: .infinity)
                .padding(DesignTokens.Spacing.m)
                .background(DesignTokens.Colors.surface)
                .cornerRadius(DesignTokens.Radius.m)
                .foregroundColor(DesignTokens.Colors.onDark)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ModeSelectView(currentScreen: .constant(.modeSelect), selectedMode: .constant(nil))
}

