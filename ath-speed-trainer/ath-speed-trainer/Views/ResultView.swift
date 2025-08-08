import SwiftUI

struct ResultView: View {
    let mode: GameMode
    let score: Int
    let correctCount: Int
    let incorrectCount: Int?
    let time: Int
    @Binding var currentScreen: AppScreen
    @State private var highScore: Int?
    @State private var isNewHighScore = false
    @State private var animateHighScore = false
    @State private var scorePulse = false

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
                _isNewHighScore = State(initialValue: true)
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
                VStack(spacing: DesignTokens.Spacing.s) {
                    Text("結果発表")
                        .font(DesignTokens.Typography.title)
                        .foregroundColor(DesignTokens.Colors.neonBlue)
                        .glow(DesignTokens.Colors.neonBlue)
                    Text(modeLabel)
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.onMuted)
                        .glow(DesignTokens.Colors.neonBlue, radius: 4)
                }

                VStack(spacing: DesignTokens.Spacing.m) {
                    switch mode {
                    case .timeAttack:
                        Text("SCORE \(String(format: "%03d", score))")
                            .font(.system(size: 48, weight: .bold, design: .monospaced))
                            .foregroundColor(DesignTokens.Colors.onDark)
                            .glow(DesignTokens.Colors.neonBlue, radius: scorePulse ? 24 : 8)
                            .scaleEffect(scorePulse ? 1.05 : 1.0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scorePulse)
                            .onAppear { scorePulse = true }
                        VStack(spacing: DesignTokens.Spacing.s) {
                            Text("\(correctCount)問正解")
                            if let incorrectCount {
                                Text("\(incorrectCount)問不正解")
                            }
                        }
                        .font(DesignTokens.Typography.body)
                        .frame(maxWidth: .infinity)
                        .padding(DesignTokens.Spacing.m)
                        .background(DesignTokens.Colors.surface)
                        .cornerRadius(DesignTokens.Radius.l)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.l)
                                .stroke(DesignTokens.Colors.onMuted.opacity(0.3), lineWidth: 1)
                        )
                        if let highScore {
                            Text("HIGH SCORE: \(String(format: "%03d", highScore))")
                                .font(DesignTokens.Typography.body)
                                .foregroundColor(animateHighScore ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.onDark)
                                .scaleEffect(animateHighScore ? 1.1 : 1.0)
                                .animation(.spring(), value: animateHighScore)
                                .onAppear {
                                    if isNewHighScore {
                                        animateHighScore = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            animateHighScore = false
                                        }
                                    }
                                }
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
                    }
                    .buttonStyle(StartButtonStyle(enabled: true))
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

