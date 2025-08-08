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
                        .padding(DesignTokens.Spacing.s)
                        .background(DesignTokens.Colors.surface)
                        .cornerRadius(DesignTokens.Radius.m)
                        .foregroundColor(DesignTokens.Colors.onDark)
                }
                .contentShape(Rectangle())
                Spacer()
            }
            .padding(.top, DesignTokens.Spacing.l)
            .padding(.leading, DesignTokens.Spacing.l)

            VStack(spacing: DesignTokens.Spacing.xl + DesignTokens.Spacing.l) {
                Text("難易度・出題形式の選択")
                    .font(DesignTokens.Typography.title)
                    .padding(.top, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    VStack(spacing: DesignTokens.Spacing.s) {
                        Text("難易度")
                            .font(DesignTokens.Typography.body)
                        HStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                            difficultyButton(title: "Easy", difficulty: .easy)
                            difficultyButton(title: "Normal", difficulty: .normal)
                            difficultyButton(title: "Hard", difficulty: .hard)
                        }
                    }

                    VStack(spacing: DesignTokens.Spacing.s) {
                        Text("出題形式")
                            .font(DesignTokens.Typography.body)
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
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.m)
                        .background((selectedDifficulty != nil && selectedStyle != nil) ? DesignTokens.Colors.neonBlue.opacity(0.2) : DesignTokens.Colors.surface)
                        .cornerRadius(DesignTokens.Radius.m)
                        .foregroundColor(DesignTokens.Colors.onDark)
                }
                .disabled(selectedDifficulty == nil || selectedStyle == nil)
                .contentShape(Rectangle())
                .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

                Spacer()
            }
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .background(DesignTokens.Colors.backgroundDark.ignoresSafeArea())
    }

    private func difficultyButton(title: String, difficulty: Difficulty) -> some View {
        Button(action: { selectedDifficulty = difficulty }) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .frame(maxWidth: .infinity)
                .padding(DesignTokens.Spacing.m)
                .background(selectedDifficulty == difficulty ? DesignTokens.Colors.neonBlue.opacity(0.6) : DesignTokens.Colors.neonBlue.opacity(0.2))
                .cornerRadius(DesignTokens.Radius.m)
                .foregroundColor(DesignTokens.Colors.onDark)
        }
        .contentShape(Rectangle())
    }

    private func styleButton(title: String, style: QuestionStyle) -> some View {
        Button(action: { selectedStyle = style }) {
            Text(title)
                .font(DesignTokens.Typography.title)
                .frame(maxWidth: .infinity)
                .padding(DesignTokens.Spacing.m)
                .background(selectedStyle == style ? DesignTokens.Colors.neonGreen.opacity(0.6) : DesignTokens.Colors.neonGreen.opacity(0.2))
                .cornerRadius(DesignTokens.Radius.m)
                .foregroundColor(DesignTokens.Colors.onDark)
        }
        .contentShape(Rectangle())
    }
}

