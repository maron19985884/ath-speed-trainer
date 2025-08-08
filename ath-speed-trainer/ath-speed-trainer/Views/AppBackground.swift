import SwiftUI

/// 共通の全画面背景画像
struct AppBackground: View {
    var body: some View {
        Image("haikei")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

#Preview {
    AppBackground()
}
