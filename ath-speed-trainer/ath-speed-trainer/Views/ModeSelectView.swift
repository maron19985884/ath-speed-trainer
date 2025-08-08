import SwiftUI

struct ModeSelectView: View {
    @Binding var currentScreen: AppScreen
    @Binding var selectedMode: GameMode?

    var body: some View {
        GeometryReader { geo in
            let contentWidth = min(geo.size.width - 24 * 2, 420)

            ScrollView {
                VStack(spacing: DesignTokens.Spacing.l) {
                    Text("Ath Speed Trainer")
                        .font(DesignTokens.Typography.title)
                        .foregroundColor(DesignTokens.Colors.onDark)
                        .bold()
                        .padding(.top, DesignTokens.Spacing.xl)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(width: contentWidth)

                    Text("モード選択")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.onMuted)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(width: contentWidth)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: DesignTokens.Spacing.m)],
                        spacing: DesignTokens.Spacing.m
                    ) {
                        modeButton(title: "タイムアタック", mode: .timeAttack)
                        modeButton(title: "10問正解タイムアタック", mode: .correctCount)
                        modeButton(title: "ミス耐久", mode: .noMistake)
                    }
                    .frame(width: contentWidth)

                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 150, maximum: 220), spacing: DesignTokens.Spacing.m)],
                        spacing: DesignTokens.Spacing.m
                    ) {
                        menuButton(title: "設定", screen: .setting)
                        menuButton(title: "クレジット", screen: .credit)
                    }
                    .frame(width: contentWidth)
                    .padding(.bottom, DesignTokens.Spacing.xl)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
            }
            .background(DesignTokens.Colors.backgroundDark.ignoresSafeArea())
        }
    }

    private func modeButton(title: String, mode: GameMode) -> some View {
        Button {
            selectedMode = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { selectedMode = mode }
        } label: {
            Text(title)
                .font(DesignTokens.Typography.title)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
        .buttonStyle(HologramButtonStyle())
        .frame(minWidth: 150, maxWidth: .infinity, minHeight: 56)
        .contentShape(Rectangle())
    }

    private func menuButton(title: String, screen: AppScreen) -> some View {
        Button(action: { currentScreen = screen }) {
            Text(title)
                .font(DesignTokens.Typography.body)
                .bold()
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
        }
        .buttonStyle(HologramButtonStyle())
        .frame(minWidth: 150, maxWidth: .infinity, minHeight: 56)
        .contentShape(Rectangle())
    }
}

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
            .padding(.horizontal, 2)
    }
}

#Preview {
    ModeSelectView(currentScreen: .constant(.modeSelect), selectedMode: .constant(nil))
}

