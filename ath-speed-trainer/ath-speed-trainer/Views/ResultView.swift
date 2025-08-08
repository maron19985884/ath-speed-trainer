import SwiftUI

struct ResultView: View {
    let mode: GameMode
    let score: Int
    let correctCount: Int
    let incorrectCount: Int?
    let time: Int
    @Binding var currentScreen: AppScreen
    @State private var highScore: Int?

    init(mode: GameMode, score: Int, correctCount: Int, incorrectCount: Int? = nil, time: Int = 0, currentScreen: Binding<AppScreen>) {
        self.mode = mode
        self.score = score
        self.correctCount = correctCount
        self.incorrectCount = incorrectCount
        self.time = time
        self._currentScreen = currentScreen
        if mode == .timeAttack {
            let saved = UserDefaults.standard.object(forKey: "HighScore") as? Int
            if let saved, saved >= score {
                _highScore = State(initialValue: saved)
            } else {
                UserDefaults.standard.set(score, forKey: "HighScore")
                _highScore = State(initialValue: score)
            }
        }
    }

    private var modeLabel: String {
        switch mode {
        case .timeAttack: return "タイムアタック"
        case .correctCount: return "10問正解タイムアタック"
        case .noMistake: return "ミス耐久"
        }
    }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
            BackButton { currentScreen = .modeSelect }

            VStack(spacing: DesignTokens.Spacing.l + DesignTokens.Spacing.xl) {
                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    Text("結果発表")
                        .font(DesignTokens.Typography.title)
                    Text(modeLabel)
                        .font(DesignTokens.Typography.title)
                }

                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    switch mode {
                    case .timeAttack:
                        Text("スコア: \(score)点")
                            .font(DesignTokens.Typography.title)
                        Text("\(correctCount)問正解")
                            .font(DesignTokens.Typography.title)
                        if let incorrectCount {
                            Text("\(incorrectCount)問不正解")
                                .font(DesignTokens.Typography.title)
                        }
                        if let highScore {
                            Text("ハイスコア: \(highScore)点")
                                .font(DesignTokens.Typography.body)
                                .padding(.top, DesignTokens.Spacing.s)
                        }
                    case .correctCount:
                        Text("時間: \(time)秒")
                            .font(DesignTokens.Typography.title)
                    case .noMistake:
                        Text("\(correctCount)問正解")
                            .font(DesignTokens.Typography.title)
                    }
                }
                
                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    Button(action: { currentScreen = .ready }) {
                        Text("もう一度プレイ")
                            .font(DesignTokens.Typography.title)
                            .frame(maxWidth: .infinity)
                            .padding(DesignTokens.Spacing.m)
                            .background(DesignTokens.Colors.neonBlue.opacity(0.2))
                            .cornerRadius(DesignTokens.Radius.m)
                            .foregroundColor(DesignTokens.Colors.onDark)
                    }
                    .contentShape(Rectangle())
                }
                .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            }

            Spacer()
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .background(DesignTokens.Colors.backgroundDark.ignoresSafeArea())
    }
}

#Preview {
    ResultView(mode: .timeAttack, score: 120, correctCount: 15, incorrectCount: 3, time: 30, currentScreen: .constant(AppScreen.result))
}

