import SwiftUI
import AVFoundation

struct GameScene: View {
    @Binding var currentScreen: AppScreen
    private let mode: GameMode
    @StateObject private var viewModel: GameSceneViewModel
    @State private var showPauseMenu = false
    @State private var countdown: Int = 0

    init(difficulty: Difficulty, mode: GameMode, currentScreen: Binding<AppScreen>, onGameEnd: @escaping (Int, Int, Int?, Int) -> Void) {
        _viewModel = StateObject(wrappedValue: GameSceneViewModel(difficulty: difficulty, mode: mode, onGameEnd: onGameEnd))
        self.mode = mode
        self._currentScreen = currentScreen
    }

    private var modeLabel: String {
        switch mode {
        case .timeAttack: return "タイムアタック"
        case .correctCount: return "10問正解タイムアタック"
        case .noMistake: return "ミス耐久"
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text(modeLabel)
                    .font(.headline)
                    .padding(.top, 16)

                HStack {
                    Text("Score: \(viewModel.score)")
                    Spacer()
                    Text("Time: \(viewModel.timeRemaining)")
                }
                .font(.title2)
                .padding(.top, 8)
                .padding(.horizontal)

                Text(viewModel.problem.question)
                    .font(.largeTitle)

                Group {
                    if let feedback = viewModel.feedback {
                        Image(systemName: feedback == .correct ? "checkmark.circle" : "xmark.circle")
                            .foregroundColor(feedback == .correct ? .green : .red)
                    } else {
                        Image(systemName: "checkmark.circle")
                            .opacity(0)
                    }
                }
                .font(.system(size: 50))
                .frame(height: 60)

                Text(viewModel.userInput)
                    .font(.title)
                    .frame(height: 40)

                keypad
            }
            .blur(radius: (showPauseMenu || countdown > 0) ? 3 : 0)

            if !viewModel.isPaused && countdown == 0 {
                VStack {
                    HStack {
                        Button(action: {
                            viewModel.pauseGame()
                            showPauseMenu = true
                        }) {
                            Image(systemName: "pause.circle")
                                .font(.title)
                        }
                        .padding(.top, 16)
                        .padding(.leading, 16)
                        Spacer()
                    }
                    Spacer()
                }
            }

            if showPauseMenu {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Button("再開") {
                        startCountdown {
                            viewModel.resumeGame()
                        }
                    }
                    Button("リセット") {
                        startCountdown {
                            viewModel.startGame()
                        }
                    }
                    Button("メニューに戻る") {
                        viewModel.stopGame()
                        currentScreen = .modeSelect
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
            }

            if countdown > 0 {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                Text("\(countdown)")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
        }
        .onAppear { viewModel.startGame() }
    }

    private var keypad: some View {
        VStack(spacing: 10) {
            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 10) {
                        ForEach(1...3, id: \.self) { col in
                            let number = row * 3 + col
                            Button(action: { viewModel.enterDigit(number) }) {
                                Text("\(number)")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                }
                HStack(spacing: 10) {
                    Button(action: { viewModel.toggleSign() }) {
                        Text("+/-")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .contentShape(Rectangle())
                    Button(action: { viewModel.enterDigit(0) }) {
                        Text("0")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .contentShape(Rectangle())
                    Button(action: { viewModel.deleteLastDigit() }) {
                        Image(systemName: "delete.left")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .contentShape(Rectangle())
                }
            }
            .frame(maxWidth: 200)

            Button(action: { viewModel.submit() }) {
                Text("Enter")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
            .contentShape(Rectangle())
        }
    }

    private func startCountdown(completion: @escaping () -> Void) {
        countdown = 3
        showPauseMenu = false
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdown -= 1
            if countdown == 0 {
                timer.invalidate()
                completion()
            }
        }
    }
}

#Preview {
    GameScene(difficulty: .easy, mode: .timeAttack, currentScreen: .constant(.game), onGameEnd: { _,_,_,_ in })
}
