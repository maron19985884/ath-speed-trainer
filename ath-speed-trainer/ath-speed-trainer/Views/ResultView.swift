import SwiftUI

struct ResultView: View {
    let mode: GameMode
    let score: Int
    let correctCount: Int
    let incorrectCount: Int?
    let time: Int
    @Binding var currentScreen: AppScreen
    @State private var highScore: Int?

    init(mode: GameMode, score: Int, correctCount: Int, incorrectCount: Int? = nil, time: Int = 0, currentScreen: Binding<AppScreen>) {
        self.mode = mode
        self.score = score
        self.correctCount = correctCount
        self.incorrectCount = incorrectCount
        self.time = time
        self._currentScreen = currentScreen
        if mode == .timeAttack {
            let saved = UserDefaults.standard.object(forKey: "HighScore") as? Int
            if let saved, saved >= score {
                _highScore = State(initialValue: saved)
            } else {
                UserDefaults.standard.set(score, forKey: "HighScore")
                _highScore = State(initialValue: score)
            }
        }
    }

    private var modeLabel: String {
        switch mode {
        case .timeAttack: return "タイムアタック"
        case .correctCount: return "10問正解タイムアタック"
        case .noMistake: return "ミス耐久"
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            BackButton { currentScreen = .modeSelect }

            VStack(spacing: 40) {
                VStack(spacing: 20) {
                    Text("結果発表")
                        .font(.largeTitle)
                    Text(modeLabel)
                        .font(.title2)
                }

                VStack(spacing: 20) {
                    switch mode {
                    case .timeAttack:
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
                    case .correctCount:
                        Text("\(correctCount)問正解")
                            .font(.title2)
                        Text("時間: \(time)秒")
                            .font(.title2)
                    case .noMistake:
                        Text("\(correctCount)問正解")
                            .font(.title2)
                    }
                }

                VStack(spacing: 20) {
                    Button(action: { currentScreen = .ready }) {
                        Text("もう一度プレイ")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .contentShape(Rectangle())
                }
                .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}

#Preview {
    ResultView(mode: .timeAttack, score: 120, correctCount: 15, incorrectCount: 3, time: 30, currentScreen: .constant(AppScreen.result))
}

