import SwiftUI

/// アプリ共通の背景（画像＋ダークオーバーレイ）
struct AppBackground: View {
    var body: some View {
        ZStack {
            Image("haikei")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // 可読性を保つためのダークオーバーレイ（調整可）
            DesignTokens.Colors.backgroundDark
                .opacity(0.45)
                .ignoresSafeArea()
        }
    }
}

/// 既存Viewに簡単に適用するためのモディファイア
extension View {
    /// 画面全体に背景画像＋オーバーレイを敷く
    func appBackground() -> some View {
        self.background(AppBackground())
    }
}
