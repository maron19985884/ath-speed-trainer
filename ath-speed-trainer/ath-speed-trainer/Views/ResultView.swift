import SwiftUI
import UIKit

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

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.l) {
            BackButton { currentScreen = .modeSelect }

            // 見出し（全モード統一）
            VStack(spacing: DesignTokens.Spacing.s) {
                Text("結果発表")
                    .font(.system(size: 32, weight: .heavy))
                    .foregroundColor(DesignTokens.Colors.onDark)
                    .overlay(
                        LinearGradient(
                            colors: [DesignTokens.Colors.neonBlue, DesignTokens.Colors.neonBlueDeep],
                            startPoint: .leading, endPoint: .trailing
                        )
                        .mask(Rectangle().frame(height: 3).offset(y: 18))
                    )
                    .glow(DesignTokens.Colors.neonBlue, radius: 8)

                Text(modeLabel)
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.onMuted)
                    .glow(DesignTokens.Colors.neonBlue, radius: 4)
            }
            .padding(.top, DesignTokens.Spacing.s)

            // コンテンツ（全モードでレイアウトトーンを統一）
            VStack(spacing: DesignTokens.Spacing.l) {
                switch mode {
                case .timeAttack:
                    // スコア表示（他モードに合わせてサイズ/余白を統一）
                    Text("SCORE  \(String(format: "%03d", score))")
                        .font(.system(size: 40, weight: .heavy, design: .monospaced))
                        .foregroundColor(DesignTokens.Colors.onDark)
                        .glow(DesignTokens.Colors.neonBlue, radius: 8)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)

                    // 詳細カード（正誤・ハイスコア）
                    VStack(spacing: DesignTokens.Spacing.s) {
                        HStack {
                            Text("\(correctCount)問正解")
                            if let incorrectCount {
                                Text("／ \(incorrectCount)問不正解")
                            }
                        }
                        if let highScore {
                            HStack(spacing: 6) {
                                Text("HIGH SCORE: \(String(format: "%03d", highScore))")
                                if isNewHighScore {
                                    Text("NEW!")
                                        .padding(.horizontal, 6).padding(.vertical, 2)
                                        .background(DesignTokens.Colors.neonGreen.opacity(0.15))
                                        .cornerRadius(6)
                                        .foregroundColor(DesignTokens.Colors.neonGreen)
                                }
                            }
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

            // アクション（全モード共通の並び・間隔）
            VStack(spacing: DesignTokens.Spacing.m) {
                Button(action: {
                    let root = UIApplication.shared.connectedScenes
                        .compactMap { ($0 as? UIWindowScene)?.windows.first { $0.isKeyWindow } }
                        .first?.rootViewController
                    // インタースティシャルは ResultView 側のポリシーに合わせて
                    InterstitialAdCoordinator.shared.show(from: root) {
                        currentScreen = .ready
                    }
                }) {
                    Text("もう一度プレイ")
                        .font(DesignTokens.Typography.title)
                }
                .buttonStyle(StartButtonStyle(enabled: true))

                if #available(iOS 16.0, *) {
                    ShareLink(
                        item: AppConstants.appStoreURL,
                        subject: Text("結果をシェア"),
                        message: Text(shareMessage())
                    ) {
                        Text(AppConstants.shareButtonTitle)
                            .font(DesignTokens.Typography.title)
                    }
                    .buttonStyle(StartButtonStyle(enabled: true))
                    .simultaneousGesture(TapGesture().onEnded {
                    })
                    .accessibilityLabel("結果を共有")
                } else {
                    Button(action: {
                        let activity = UIActivityViewController(
                            activityItems: [shareMessage(), AppConstants.appStoreURL],
                            applicationActivities: nil
                        )
                        UIApplication.shared.connectedScenes
                            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
                            .first?
                            .present(activity, animated: true)
                    }) {
                        Text(AppConstants.shareButtonTitle)
                            .font(DesignTokens.Typography.title)
                    }
                    .buttonStyle(StartButtonStyle(enabled: true))
                    .accessibilityLabel("結果を共有")
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)

            Spacer(minLength: 0)
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .appBackground()
        .safeAreaInset(edge: .bottom) {
            AdBannerView().padding(.top, 8)
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
