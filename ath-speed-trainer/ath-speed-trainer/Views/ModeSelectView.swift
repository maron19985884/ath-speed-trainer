import SwiftUI

struct ModeSelectView: View {
    @Binding var currentScreen: AppScreen
    @Binding var selectedMode: GameMode?

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.isLandscape
            let sidePadding = isLandscape ? (DesignTokens.Spacing.l + DesignTokens.Spacing.xl + 20) : (DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            let maxWidth: CGFloat = isLandscape ? 700 : .infinity

            VStack(spacing: DesignTokens.Spacing.xl) {
                Text("モード選択")
                    .font(DesignTokens.Typography.title)
                    .foregroundColor(DesignTokens.Colors.onDark)
                    .glow(DesignTokens.Colors.neonBlue, radius: 8)
                    .padding(.top, DesignTokens.Spacing.xl)
                    .padding(.bottom, DesignTokens.Spacing.l)

                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    modeButton(title: "タイムアタック", mode: .timeAttack)
                    modeButton(title: "10問正解スピード", mode: .correctCount)
                    modeButton(title: "ミス耐久", mode: .noMistake)
                }
                .frame(maxWidth: maxWidth)
                .padding(.horizontal, sidePadding)

                Spacer()

                VStack(spacing: DesignTokens.Spacing.s) {
                    smallMenuButton(title: "設定", screen: .setting)
                    smallMenuButton(title: "クレジット", screen: .credit)
                    smallMenuButton(title: "タイトルへ戻る", screen: .title)
                }
                .frame(maxWidth: maxWidth)
                .padding(.horizontal, sidePadding)
                .padding(.bottom, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            }
            .appBackground()
        }
    }

    // モードボタン（大）
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
        .buttonStyle(HologramButtonStyle()) // 既存大サイズ
    }

    // サブメニュー（小）
    private func smallMenuButton(title: String, screen: AppScreen) -> some View {
        Button(action: {
           
            currentScreen = screen
        }) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .bold()
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .frame(minWidth: 120, maxWidth: .infinity, minHeight: 56)
        }
        .buttonStyle(SmallHologramButtonStyle())
    }
}

// 大ボタンスタイル（既存）
struct HologramButtonStyle: ButtonStyle {
    var isSelected: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let color = isSelected ? DesignTokens.Colors.neonPurple : DesignTokens.Colors.neonBlue
        let radius: CGFloat = (isSelected || configuration.isPressed) ? 12 : 6

        return configuration.label
            .frame(minWidth: 120, maxWidth: .infinity, minHeight: 56)
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

// 小ボタンスタイル
struct SmallHologramButtonStyle: ButtonStyle {
    var isSelected: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let color = isSelected ? DesignTokens.Colors.neonPurple : DesignTokens.Colors.neonBlue
        let radius: CGFloat = (isSelected || configuration.isPressed) ? 8 : 4

        return configuration.label
            .background(DesignTokens.Colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                    .stroke(color.opacity(0.7), lineWidth: 1)
            )
            .foregroundColor(DesignTokens.Colors.onDark)
            .cornerRadius(DesignTokens.Radius.m)
            .glow(color, radius: radius)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ModeSelectView(currentScreen: .constant(.modeSelect), selectedMode: .constant(nil))
}
