import SwiftUI

/// ゲーム開始前のカウントダウンを表示するビュー
struct ReadyCountdownView: View {
    /// 画面遷移制御
    @Binding var currentScreen: AppScreen
    /// 表示するテキストのインデックス
    @State private var index: Int = 0
    /// カウントダウンで表示する文字列
    private let steps = ["3", "2", "1","GO!"]

    var body: some View {
        Text(steps[index])
            .font(DesignTokens.Typography.digitalMono)
            .scaleEffect(2.4)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(DesignTokens.Colors.neonBlue)
            .glow(DesignTokens.Colors.neonBlue)
            .background(AppBackground())
            .onAppear(perform: startCountdown)
    }

    /// 1秒ごとに文字を切り替え、終了後にゲーム画面へ遷移
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if index < steps.count - 1 {
                index += 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    currentScreen = .game
                }
            }
        }
    }
}

#Preview {
    ReadyCountdownView(currentScreen: .constant(.ready))
}
