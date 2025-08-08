import SwiftUI

struct DifficultySelectView: View {
    @Binding var selectedDifficulty: Difficulty?
    @Binding var selectedStyle: QuestionStyle?
    @Binding var currentScreen: AppScreen
    var startGame: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { currentScreen = .modeSelect }) {
                    Text("メニューに戻る")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.onDark)
                        .padding(DesignTokens.Spacing.s)
                        .background(DesignTokens.Colors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                                .stroke(DesignTokens.Colors.neonBlue.opacity(0.5), lineWidth: 1)
                        )
                        .cornerRadius(DesignTokens.Radius.m)
                }
                Spacer()
            }
            .padding(.top, DesignTokens.Spacing.l)
            .padding(.leading, DesignTokens.Spacing.l)

            VStack(spacing: DesignTokens.Spacing.xl + DesignTokens.Spacing.l) {
                Text("難易度・出題形式の選択")
                    .font(DesignTokens.Typography.title)
                    .foregroundColor(DesignTokens.Colors.onDark)
                    .padding(.top, DesignTokens.Spacing.xl)

                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    VStack(spacing: DesignTokens.Spacing.s) {
                        Text("難易度")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.onDark)
                        HStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                            difficultyButton(title: "Easy", difficulty: .easy)
                            difficultyButton(title: "Normal", difficulty: .normal)
                            difficultyButton(title: "Hard", difficulty: .hard)
                        }
                    }

                    VStack(spacing: DesignTokens.Spacing.s) {
                        Text("出題形式")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.onDark)
                        HStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                            styleButton(title: "1つずつ出題", style: .single)
                            styleButton(title: "続けて計算", style: .sequence)
                            styleButton(title: "ランダム出題", style: .mixed)
                        }
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

                Button(action: startGame) {
                    Text("ゲーム開始")
                        .font(DesignTokens.Typography.title)
                        .bold()
                }
                .buttonStyle(StartButtonStyle(enabled: selectedDifficulty != nil && selectedStyle != nil))
                .disabled(selectedDifficulty == nil || selectedStyle == nil)
                .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

                Spacer()
            }
        }
        .background(DesignTokens.Colors.backgroundDark.ignoresSafeArea())
    }

    private func difficultyButton(title: String, difficulty: Difficulty) -> some View {
        let selected = selectedDifficulty == difficulty
        return Button(action: { selectedDifficulty = difficulty }) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .bold()
        }
        .buttonStyle(HologramButtonStyle(isSelected: selected))
        .accessibilityLabel(Text(selected ? "\(title) 選択中" : title))
    }

    private func styleButton(title: String, style: QuestionStyle) -> some View {
        let selected = selectedStyle == style
        return Button(action: { selectedStyle = style }) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .bold()
        }
        .buttonStyle(HologramButtonStyle(isSelected: selected))
        .accessibilityLabel(Text(selected ? "\(title) 選択中" : title))
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

struct StartButtonStyle: ButtonStyle {
    var enabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .frame(maxWidth: .infinity, minWidth: 120, minHeight: 56)
            .padding(DesignTokens.Spacing.m)
            .background(
                Group {
                    if enabled {
                        LinearGradient(colors: [DesignTokens.Colors.neonBlue, DesignTokens.Colors.neonBlueDeep], startPoint: .topLeading, endPoint: .bottomTrailing)
                    } else {
                        DesignTokens.Colors.surface.opacity(0.5)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.l)
                    .stroke(DesignTokens.Colors.neonBlue.opacity(0.7), lineWidth: 1.5)
            )
            .foregroundColor(.white)
            .cornerRadius(DesignTokens.Radius.l)
            .glow(DesignTokens.Colors.neonBlue, radius: enabled ? (configuration.isPressed ? 12 : 8) : 0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

