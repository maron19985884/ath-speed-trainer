import SwiftUI

struct DifficultySelectView: View {
    @Binding var selectedDifficulty: Difficulty?
    @Binding var selectedStyle: QuestionStyle?
    @Binding var currentScreen: AppScreen
    var startGame: () -> Void

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.isLandscape
            let minCardWidth: CGFloat = isLandscape ? 200 : 140
            let hPadding: CGFloat = isLandscape ? 32 : DesignTokens.Spacing.l

            VStack(spacing: 0) {
                BackButton { currentScreen = .modeSelect }

                ScrollView {
                    VStack(spacing: DesignTokens.Spacing.xl) {
                        Text("難易度・出題形式の選択")
                            .font(DesignTokens.Typography.title)
                            .padding(.top, DesignTokens.Spacing.xl)

                        VStack(spacing: DesignTokens.Spacing.m) {
                            Text("難易度")
                                .font(DesignTokens.Typography.body)

                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: minCardWidth), spacing: DesignTokens.Spacing.m)],
                                spacing: DesignTokens.Spacing.m
                            ) {
                                difficultyButton(title: "Easy",   difficulty: .easy)
                                difficultyButton(title: "Normal", difficulty: .normal)
                                difficultyButton(title: "Hard",   difficulty: .hard)
                            }
                        }
                        .padding(.horizontal, hPadding)

                        VStack(spacing: DesignTokens.Spacing.m) {
                            Text("出題形式")
                                .font(DesignTokens.Typography.body)

                            LazyVGrid(
                                columns: [GridItem(.adaptive(minimum: minCardWidth), spacing: DesignTokens.Spacing.m)],
                                spacing: DesignTokens.Spacing.m
                            ) {
                                styleButton(title: "単発計算",  style: .single)
                                styleButton(title: "連続計算",  style: .sequence)
                                styleButton(title: "ランダム計算", style: .mixed)
                            }
                        }
                        .padding(.horizontal, hPadding)

                        Button(action: {
                            SEManager.shared.play(.countdown)
                            startGame()
                        }) {
                            Text("ゲーム開始")
                                .font(DesignTokens.Typography.title)
                                .bold()
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .buttonStyle(
                            DifficultyStartButtonStyle(
                                enabled: selectedDifficulty != nil && selectedStyle != nil
                            )
                        )
                        .disabled(selectedDifficulty == nil || selectedStyle == nil)
                        .padding(.horizontal, isLandscape ? 48 : DesignTokens.Spacing.l)
                        .padding(.bottom, DesignTokens.Spacing.xl)
                    }
                    .frame(maxWidth: isLandscape ? 900 : 700)
                    .padding(.vertical, DesignTokens.Spacing.l)
                }
            }
            .appBackground()
        }
    }

    private func difficultyButton(title: String, difficulty: Difficulty) -> some View {
        let selected = selectedDifficulty == difficulty
        return Button(action: {
            SEManager.shared.play(.button)
            selectedDifficulty = difficulty
        }) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
        }
        .buttonStyle(DifficultyCardButtonStyle(isSelected: selected))
        .accessibilityLabel(Text(selected ? "\(title) 選択中" : title))
        .contentShape(Rectangle())
    }

    private func styleButton(title: String, style: QuestionStyle) -> some View {
        let selected = selectedStyle == style
        return Button(action: {
            SEManager.shared.play(.button)
            selectedStyle = style
        }) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
        }
        .buttonStyle(DifficultyCardButtonStyle(isSelected: selected))
        .accessibilityLabel(Text(selected ? "\(title) 選択中" : title))
        .contentShape(Rectangle())
    }
}

// MARK: - Local Styles (fileprivate で衝突回避)

fileprivate struct DifficultyCardButtonStyle: ButtonStyle {
    var isSelected: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let color = isSelected ? DesignTokens.Colors.neonPurple : DesignTokens.Colors.neonBlue
        let glowRadius: CGFloat = (isSelected || configuration.isPressed) ? 12 : 6

        return configuration.label
            // Gridセル幅に追従（minWidthで高さ確保・maxWidthはセル内で拡張）
            .frame(minWidth: 120, maxWidth: .infinity, minHeight: 56)
            .padding(DesignTokens.Spacing.m)
            .background(DesignTokens.Colors.surface)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.l)
                    .stroke(color.opacity(0.7), lineWidth: 1.5)
            )
            .foregroundColor(DesignTokens.Colors.onDark)
            .cornerRadius(DesignTokens.Radius.l)
            .glow(color, radius: glowRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

fileprivate struct DifficultyStartButtonStyle: ButtonStyle {
    var enabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // 横幅は親の読みやすい最大幅（paddingと組み合わせ）
            .frame(minWidth: 120, maxWidth: .infinity, minHeight: 56)
            .padding(DesignTokens.Spacing.m)
            .background(
                Group {
                    if enabled {
                        LinearGradient(
                            colors: [DesignTokens.Colors.neonBlue, DesignTokens.Colors.neonBlueDeep],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
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
