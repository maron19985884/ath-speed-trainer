import SwiftUI

/// 画面全体に適用する共通背景ビュー
struct BackgroundView: View {
    var body: some View {
        Image("haikei")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .overlay(Color.black.opacity(0.5).ignoresSafeArea())
    }
}

extension View {
    /// アプリ共通の背景画像とオーバーレイを適用
    func appBackground() -> some View {
        self.background(BackgroundView())
    }
}
