import SwiftUI

struct ResultView: View {
    let score: Int
    let correctCount: Int
    let incorrectCount: Int?
    @Binding var currentScreen: AppScreen
    @State private var highScore: Int?

    init(score: Int, correctCount: Int, incorrectCount: Int? = nil, currentScreen: Binding<AppScreen>) {
        self.score = score
        self.correctCount = correctCount
        self.incorrectCount = incorrectCount
        self._currentScreen = currentScreen
        let saved = UserDefaults.standard.object(forKey: "HighScore") as? Int
        if let saved, saved >= score {
            _highScore = State(initialValue: saved)
        } else {
            UserDefaults.standard.set(score, forKey: "HighScore")
            _highScore = State(initialValue: score)
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            BackButton { currentScreen = .modeSelect }

            VStack(spacing: 40) {
                Text("結果発表")
                    .font(.largeTitle)

                VStack(spacing: 20) {
                    Text("スコア: \(score)点")
                        .font(.title2)
                    Text("\(correctCount)問正解")
                        .font(.title2)
                    if let incorrectCount {
                        Text("\(incorrectCount)問不正解")
                            .font(.title2)
                    }
                    if let highScore {
                        Text("ハイスコア: \(highScore)点")
                            .font(.title3)
                            .padding(.top, 10)
                    }
                }

                VStack(spacing: 20) {
                    Button("もう一度プレイ") {
                        currentScreen = .game
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
                }
                .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}

#Preview {
    ResultView(score: 120, correctCount: 15, incorrectCount: 3, currentScreen: .constant(AppScreen.result))
}

