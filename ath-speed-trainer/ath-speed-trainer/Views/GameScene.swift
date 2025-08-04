import SwiftUI
import AVFoundation

struct GameScene: View {
    @Binding var currentScreen: AppScreen
    @StateObject private var viewModel: GameSceneViewModel
    @State private var showPauseMenu = false
    @State private var countdown: Int = 0

    init(difficulty: Difficulty, mode: GameMode, currentScreen: Binding<AppScreen>, onGameEnd: @escaping (Int, Int, Int?, Int) -> Void) {
        _viewModel = StateObject(wrappedValue: GameSceneViewModel(difficulty: difficulty, mode: mode, onGameEnd: onGameEnd))
        self._currentScreen = currentScreen
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Score: \(viewModel.score)")
                        if let delta = viewModel.scoreDelta {
                            Text((delta > 0 ? "+\(delta)" : "\(delta)") + "点")
                                .foregroundColor(delta > 0 ? .green : .red)
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut, value: viewModel.scoreDelta)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Time: \(viewModel.timeRemaining)")
                        if let delta = viewModel.timeDelta {
                            Text("+\(delta)秒")
                                .foregroundColor(.green)
                                .transition(.opacity)
                        }
                    }
                    .animation(.easeInOut, value: viewModel.timeDelta)
                }
                .font(.title2)
                .padding()

                Text(viewModel.problem.question)
                    .font(.largeTitle)

                if let feedback = viewModel.feedback {
                    Image(systemName: feedback == .correct ? "checkmark.circle" : "xmark.circle")
                        .foregroundColor(feedback == .correct ? .green : .red)
                        .font(.system(size: 50))
                }

                Text(viewModel.userInput)
                    .font(.title)

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
                        startCountdown()
                    }
                    Button("リセット") {
                        viewModel.startGame()
                        showPauseMenu = false
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

    private func startCountdown() {
        countdown = 3
        showPauseMenu = false
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdown -= 1
            if countdown == 0 {
                timer.invalidate()
                viewModel.resumeGame()
            }
        }
    }
}

#Preview {
    GameScene(difficulty: .easy, mode: .timeAttack, currentScreen: .constant(.game), onGameEnd: { _,_,_,_ in })
}
