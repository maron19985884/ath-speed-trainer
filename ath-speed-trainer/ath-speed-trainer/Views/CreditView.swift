import SwiftUI

struct CreditView: View {
    @Binding var currentScreen: AppScreen

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Button("メニューに戻る") {
                    currentScreen = .modeSelect
                }
                .font(.title3)
                Spacer()
            }
            .padding(.top, 16)
            .padding(.leading, 16)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Ath Speed Trainer")
                        .font(.title)

                    Group {
                        Text("開発者")
                            .font(.headline)
                        Text("Keita Kobayashi")
                    }

                    Group {
                        Text("使用素材")
                            .font(.headline)
                        Text("アイコン：Flaticon\n効果音：効果音ラボ")
                            .multilineTextAlignment(.leading)
                    }

                    Group {
                        Text("ライセンス")
                            .font(.headline)
                        Text("このアプリはMITライセンスに基づいて公開されています。\n使用素材の著作権は各提供元に帰属します。")
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    CreditView(currentScreen: .constant(AppScreen.modeSelect))
}

