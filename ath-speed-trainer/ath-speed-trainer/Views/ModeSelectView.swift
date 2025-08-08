import SwiftUI

struct ModeSelectView: View {
    @Binding var currentScreen: AppScreen
    @Binding var selectedMode: GameMode?

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            // タイトル画像を挿入
            Image("titlelogo") // Assets.xcassets に追加した画像名
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 1600) // 横幅の上限
                .padding(.top, DesignTokens.Spacing.xl)
                .padding(.bottom, DesignTokens.Spacing.l)


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
        .background(AppBackground())
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

/// タイトル専用ビュー（サイズ・ネオン・下線で強調）
fileprivate struct NeonTitle: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Ath Speed Trainer")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundColor(DesignTokens.Colors.neonBlue)
                // 発光感を強める二重シャドウ＋カスタムglow
                .shadow(color: DesignTokens.Colors.neonBlue.opacity(0.6), radius: 12, x: 0, y: 0)
                .shadow(color: DesignTokens.Colors.neonBlue.opacity(0.3), radius: 24, x: 0, y: 0)
                .glow(DesignTokens.Colors.neonBlue, radius: 10)
                .padding(.top, DesignTokens.Spacing.xl)

            // グラデ下線バーで主見出しを固定
            RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                .fill(
                    LinearGradient(
                        colors: [DesignTokens.Colors.neonBlue, DesignTokens.Colors.neonBlueDeep],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(height: 6)
                .glow(DesignTokens.Colors.neonBlue, radius: 6)
                .padding(.horizontal, DesignTokens.Spacing.l)
        }
        .padding(.bottom, DesignTokens.Spacing.l)
    }
}

// 既存ボタンスタイル
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

#Preview {
    ModeSelectView(currentScreen: .constant(.modeSelect), selectedMode: .constant(nil))
}
