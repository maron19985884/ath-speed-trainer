import SwiftUI

struct DifficultySelectView: View {
    @Binding var selectedDifficulty: Difficulty?
    @Binding var selectedStyle: QuestionStyle?
    @Binding var currentScreen: AppScreen
    var startGame: () -> Void

    var body: some View {
        HStack {
            Button(action: { currentScreen = .modeSelect }) {
                Text("メニューに戻る")
                    .font(.title3)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .contentShape(Rectangle())
            Spacer()
        }
        .padding(.top, 16)
        .padding(.leading, 16)
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
                        styleButton(title: "1つずつ出題", style: .single)
                        styleButton(title: "続けて計算", style: .sequence)
                        styleButton(title: "ランダム出題", style: .mixed)
                    }
                }
            }
            .padding(.horizontal, 40)

            Button(action: startGame) {
                Text("ゲーム開始")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((selectedDifficulty != nil && selectedStyle != nil) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .disabled(selectedDifficulty == nil || selectedStyle == nil)
            .contentShape(Rectangle())
            .padding(.horizontal, 40)

            Spacer()

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
        .contentShape(Rectangle())
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
        .contentShape(Rectangle())
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

