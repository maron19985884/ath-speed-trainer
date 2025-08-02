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

    var body: some View {
        switch currentScreen {
        case .modeSelect:
            ModeSelectView(selectedMode: $selectedMode)
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
            GameScene(difficulty: selectedDifficulty ?? .easy)

        case .result:
            // TODO: 実装予定のリザルト画面
            Text("ResultView")

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

