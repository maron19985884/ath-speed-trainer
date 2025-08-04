import SwiftUI

struct DifficultySelectView: View {
    @Binding var selectedDifficulty: Difficulty?
    @Binding var selectedStyle: QuestionStyle?
    @Binding var currentScreen: AppScreen
    var startGame: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Text("難易度・出題形式の選択")
                .font(.largeTitle)
                .padding(.top, 40)

            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    Text("難易度")
                    HStack(spacing: 20) {
                        difficultyButton(title: "Easy", difficulty: .easy)
                        difficultyButton(title: "Normal", difficulty: .normal)
                        difficultyButton(title: "Hard", difficulty: .hard)
                    }
                }

                VStack(spacing: 10) {
                    Text("出題形式")
                    HStack(spacing: 20) {
                        styleButton(title: "単一演算", style: .single)
                        styleButton(title: "連続演算", style: .sequence)
                        styleButton(title: "ランダム", style: .mixed)
                    }
                }
            }
            .padding(.horizontal, 40)

            Button(action: startGame) {
                Text("ゲーム開始")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 40)

            Spacer()

            Button("メニューに戻る") {
                currentScreen = .modeSelect
            }
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    private func difficultyButton(title: String, difficulty: Difficulty) -> some View {
        Button(action: { selectedDifficulty = difficulty }) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedDifficulty == difficulty ? Color.blue.opacity(0.6) : Color.blue.opacity(0.2))
                .cornerRadius(8)
        }
    }

    private func styleButton(title: String, style: QuestionStyle) -> some View {
        Button(action: { selectedStyle = style }) {
            Text(title)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedStyle == style ? Color.green.opacity(0.6) : Color.green.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

#Preview {
    DifficultySelectView(
        selectedDifficulty: .constant(.easy),
        selectedStyle: .constant(.single),
        currentScreen: .constant(.modeSelect),
        startGame: {}
    )
}

