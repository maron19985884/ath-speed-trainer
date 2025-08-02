import SwiftUI

typealias AppScreen = ContentView.AppScreen

struct CreditView: View {
    @Binding var currentScreen: AppScreen

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Ath Speed Trainer")
                    .font(.title)
                    .padding(.top, 40)

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

                Button("設定に戻る") {
                    currentScreen = .setting
                }
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.top, 40)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    CreditView(currentScreen: .constant(.setting))
}

