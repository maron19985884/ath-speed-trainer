import SwiftUI

// MARK: - Button Style
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

// MARK: - Result View
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
    @State private var isShareSheetPresented = false

    init(
        mode: GameMode,
        score: Int,
        correctCount: Int,
        incorrectCount: Int? = nil,
        time: Int = 0,
        currentScreen: Binding<AppScreen>
    ) {
        self.mode = mode
        self.score = score
        self.correctCount = correctCount
        self.incorrectCount = incorrectCount
        self.time = time
        self._currentScreen = currentScreen

        // HighScore 保存（タイムアタックのみ）
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

    // MARK: - Labels
    private var modeLabel: String {
        switch mode {
        case .timeAttack:   return "タイムアタック"
        case .correctCount: return "10問正解スピード"
        case .noMistake:    return "ミス耐久"
        }
    }

    // MARK: - Share message
    private func shareMessage() -> String {
        switch mode {
        case .timeAttack:
            return "タイムアタックで SCORE \(String(format: "%03d", score))！挑戦してみて #計算トレ"
        case .correctCount:
            return "\(correctCount)問正解スピード: \(time)秒！ #計算トレ"
        case .noMistake:
            return "ミス耐久で \(correctCount)問連続正解！ #計算トレ"
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.l) {
            BackButton { currentScreen = .modeSelect }

            // 見出し
            VStack(spacing: DesignTokens.Spacing.s) {
                Text("結果発表")
                    .font(.system(size: 36, weight: .heavy))
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

            // コンテンツ
            VStack(spacing: DesignTokens.Spacing.l) {

                switch mode {
                case .timeAttack:
                    // スコア強調
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

                    // 詳細
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
                        .font(.system(size: 40, weight: .heavy))
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
                Button(action: { currentScreen = .ready }) {
                    Text("もう一度プレイ")
                        .font(DesignTokens.Typography.title)
                }
                .buttonStyle(StartButtonStyle(enabled: true))

                // 共有
                if #available(iOS 16.0, *) {
                    ShareLink(
                        item: AppConstants.appStoreURL,      // URL (Transferable)
                        subject: Text("結果をシェア"),
                        message: Text(shareMessage())
                    ) {
                        Text(AppConstants.shareButtonTitle)
                            .font(DesignTokens.Typography.title)
                    }
                    .buttonStyle(StartButtonStyle(enabled: true))
                    .simultaneousGesture(TapGesture().onEnded {
                        SEManager.shared.play(.decide)
                    })
                    .accessibilityLabel("結果を共有")
                } else {
                    Button(action: {
                        SEManager.shared.play(.decide)
                        isShareSheetPresented = true
                    }) {
                        Text(AppConstants.shareButtonTitle)
                            .font(DesignTokens.Typography.title)
                    }
                    .buttonStyle(StartButtonStyle(enabled: true))
                    .accessibilityLabel("結果を共有")
                    .sheet(isPresented: $isShareSheetPresented) {
                        ShareSheet(activityItems: [shareMessage(), AppConstants.appStoreURL])
                    }
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

            Spacer(minLength: 0)
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .appBackground()
    }
}

// MARK: - Preview
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


