import SwiftUI

/// アプリ全体の画面遷移を管理するトップレベルビュー
struct ContentView: View {
    /// 現在表示中の画面
    @State private var currentScreen: AppScreen = .modeSelect

    /// 選択されたゲームモード
    @State private var selectedMode: GameMode?

    /// 選択された難易度
    @State private var selectedDifficulty: Difficulty?

    /// 選択された出題形式
    @State private var selectedStyle: QuestionStyle?

    /// ゲーム結果
    @State private var finalScore: Int = 0
    @State private var correctCount: Int = 0
    @State private var incorrectCount: Int = 0

    var body: some View {
        switch currentScreen {
        case .modeSelect:
            ModeSelectView(currentScreen: $currentScreen, selectedMode: $selectedMode)
                .onChange(of: selectedMode) { _, newValue in
                    if newValue != nil {
                        currentScreen = .difficultySelect
                    }
                }

        case .difficultySelect:
            DifficultySelectView(
                selectedDifficulty: $selectedDifficulty,
                selectedStyle: $selectedStyle,
                startGame: {
                    currentScreen = .game
                }
            )

        case .game:
            GameScene(
                difficulty: selectedDifficulty ?? .easy,
                currentScreen: $currentScreen,
                onGameEnd: { score, correct, incorrect in
                    finalScore = score
                    correctCount = correct
                    incorrectCount = incorrect
                    currentScreen = .result
                }
            )

        case .result:
            ResultView(
                score: finalScore,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                currentScreen: $currentScreen
            )

        case .setting:
            SettingView(currentScreen: $currentScreen)

        case .credit:
            CreditView(currentScreen: $currentScreen)
        }
    }
}

#Preview {
    ContentView()
}

