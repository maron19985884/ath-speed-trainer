import SwiftUI

// Custom button style used by ResultView
struct StartButtonStyle: ButtonStyle {
    let enabled: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignTokens.Spacing.m)
            .background(enabled ? DesignTokens.Colors.neonBlue : DesignTokens.Colors.surface)
            .foregroundColor(enabled ? DesignTokens.Colors.backgroundDark : DesignTokens.Colors.onMuted)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .cornerRadius(DesignTokens.Radius.l)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.l)
                    .stroke(DesignTokens.Colors.onMuted.opacity(0.3), lineWidth: 1)
            )
    }
}

struct ResultView: View {
    let mode: GameMode
    let score: Int
    let correctCount: Int
    let incorrectCount: Int?
    let time: Int
    @Binding var currentScreen: AppScreen
    @State private var highScore: Int? = nil
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
        case .correctCount: return "10問正解スピード"
        case .noMistake: return "ミス耐久"
        }
    }

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.l) {
            BackButton { currentScreen = .modeSelect }

            // 見出しブロック（強調）
            VStack(spacing: DesignTokens.Spacing.s) {
                Text("結果発表")
                    .font(.system(size: 36, weight: .heavy)) // ← ひと回り大きく
                    .foregroundColor(DesignTokens.Colors.onDark)
                    .overlay(
                        LinearGradient(
                            colors: [DesignTokens.Colors.neonBlue, DesignTokens.Colors.neonBlueDeep],
                            startPoint: .leading, endPoint: .trailing
                        )
                        .mask(
                            Rectangle()
                                .frame(height: 4)
                                .offset(y: 20)
                        )
                    )
                    .glow(DesignTokens.Colors.neonBlue, radius: 10)

                Text(modeLabel)
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.onMuted)
                    .glow(DesignTokens.Colors.neonBlue, radius: 4)
            }
            .padding(.top, DesignTokens.Spacing.s)

            // コンテンツブロック
            VStack(spacing: DesignTokens.Spacing.l) {

                switch mode {
                case .timeAttack:
                    // スコアを主役に（72pt, 等幅, グロー強）
                    ZStack(alignment: .topTrailing) {
                        Text(String(format: "SCORE  %03d", score))
                            .font(.system(size: 72, weight: .black, design: .monospaced))
                            .foregroundColor(DesignTokens.Colors.onDark)
                            .glow(DesignTokens.Colors.neonBlue, radius: scorePulse ? 28 : 12)
                            .scaleEffect(scorePulse ? 1.04 : 1.0)
                            .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: scorePulse)
                            .onAppear { scorePulse = true }
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        if isNewHighScore {
                            HStack(spacing: 6) {
                                Image(systemName: "trophy.fill")
                                Text("NEW RECORD")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(DesignTokens.Colors.neonGreen.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(DesignTokens.Colors.neonGreen.opacity(0.6), lineWidth: 1)
                            )
                            .cornerRadius(10)
                            .foregroundColor(DesignTokens.Colors.neonGreen)
                            .offset(x: 4, y: -8)
                            .transition(.scale)
                            .onAppear {
                                animateHighScore = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    animateHighScore = false
                                }
                            }
                        }
                    }

                    // 詳細（正誤など）
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
                        Text("HIGH SCORE  \(String(format: "%03d", highScore))")
                            .font(.system(size: 18, weight: .semibold, design: .monospaced))
                            .foregroundColor(DesignTokens.Colors.onDark)
                            .padding(.top, DesignTokens.Spacing.s)
                    }

                case .correctCount:
                    Text("時間  \(time) 秒")
                        .font(.system(size: 40, weight: .heavy)) // → 見出し級に
                        .glow(DesignTokens.Colors.neonBlue, radius: 8)

                case .noMistake:
                    Text("\(correctCount)問正解")
                        .font(.system(size: 40, weight: .heavy))
                        .glow(DesignTokens.Colors.neonBlue, radius: 8)
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.l)

            // アクション
            VStack(spacing: DesignTokens.Spacing.m) {
                Button(action: {
                    currentScreen = .ready
                }) {
                    Text("もう一度プレイ")
                        .font(DesignTokens.Typography.title)
                }
                .buttonStyle(StartButtonStyle(enabled: true))
            }
            .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

            Spacer(minLength: 0)
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .appBackground()
    }
}

#Preview {
    ResultView(
        mode: .timeAttack,
        score: 120,
        correctCount: 15,
        incorrectCount: 3,
        time: 30,
        currentScreen: .constant(.result)
    )
}
