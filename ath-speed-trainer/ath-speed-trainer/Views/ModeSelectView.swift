import SwiftUI

struct ModeSelectView: View {
    @Binding var selectedMode: GameMode?

    var body: some View {
        VStack(spacing: 40) {
            Text("モード選択")
                .font(.largeTitle)
                .padding(.top, 40)

            VStack(spacing: 20) {
                modeButton(title: "タイムアタック", mode: .timeAttack)
                modeButton(title: "正解数チャレンジ", mode: .correctCount)
                modeButton(title: "ミス耐久", mode: .suddenDeath)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }

    private func modeButton(title: String, mode: GameMode) -> some View {
        Button(action: { selectedMode = mode }) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

#Preview {
    ModeSelectView(selectedMode: .constant(nil))
}

