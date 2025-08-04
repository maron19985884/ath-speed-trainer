import SwiftUI

struct ModeSelectView: View {
    @Binding var currentScreen: AppScreen
    @Binding var selectedMode: GameMode?

    var body: some View {
        VStack(spacing: 40) {
            Text("モード選択")
                .font(.largeTitle)
                .padding(.top, 40)

            VStack(spacing: 20) {
                modeButton(title: "タイムアタック", mode: .timeAttack)
                modeButton(title: "正解数チャレンジ", mode: .correctCount)
                modeButton(title: "ミス耐久", mode: .noMistake)
            }
            .padding(.horizontal, 40)

            Spacer()

            VStack(spacing: 20) {
                menuButton(title: "設定", screen: .setting)
                menuButton(title: "クレジット", screen: .credit)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    private func modeButton(title: String, mode: GameMode) -> some View {
        Button(action: {
            selectedMode = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                selectedMode = mode
            }
        }) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
        }
        .contentShape(Rectangle())
    }

    private func menuButton(title: String, screen: AppScreen) -> some View {
        Button(action: { currentScreen = screen }) {
            Text(title)
                .font(.title3)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ModeSelectView(currentScreen: .constant(.modeSelect), selectedMode: .constant(nil))
}

