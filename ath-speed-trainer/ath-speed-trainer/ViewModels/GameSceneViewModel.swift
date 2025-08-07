import SwiftUI
import AVFoundation

final class GameSceneViewModel: ObservableObject {
    @Published var problem: ArithmeticProblem
    @Published var userInput: String = ""
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 30
    @Published var feedback: Feedback? = nil
    @Published var correctCount: Int = 0
    @Published var incorrectCount: Int = 0
    @Published var answeredCount: Int = 0
    @Published var scoreDelta: Int? = nil
    @Published var timeDelta: Int? = nil
    @Published var isPaused: Bool = false
    @Published var comboCount: Int = 0
    @Published var showCombo: Bool = false

    @AppStorage("isSeOn") private var isSeOn: Bool = true
    @AppStorage("isVibrationOn") private var isVibrationOn: Bool = true

    enum Feedback { case correct, wrong }

    private let difficulty: Difficulty
    private let mode: GameMode
    private var timer: Timer?
    private let questionLimit = 10
    private var isGameOver = false
    private let onGameEnd: ((Int, Int, Int?, Int) -> Void)?

    init(difficulty: Difficulty, mode: GameMode, onGameEnd: ((Int, Int, Int?, Int) -> Void)? = nil) {
        self.difficulty = difficulty
        self.mode = mode
        self.onGameEnd = onGameEnd
        self.problem = ProblemGenerator.generate(difficulty: difficulty, score: 0)
    }

    func startGame() {
        timer?.invalidate()
        score = 0
        userInput = ""
        feedback = nil
        correctCount = 0
        incorrectCount = 0
        answeredCount = 0
        comboCount = 0
        showCombo = false
        isGameOver = false
        isPaused = false
        problem = ProblemGenerator.generate(difficulty: difficulty, score: score)

        switch mode {
        case .timeAttack:
            timeRemaining = 30
        case .correctCount, .noMistake:
            timeRemaining = 0
        }

        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        switch mode {
        case .timeAttack:
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self else { return }
                self.timeRemaining -= 1
                if self.timeRemaining <= 0 {
                    self.endGame()
                }
            }
        case .correctCount, .noMistake:
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.timeRemaining += 1
            }
        }
    }

    private func endGame() {
        timer?.invalidate()
        isGameOver = true
        let time = timeRemaining
        onGameEnd?(score, correctCount, mode == .timeAttack ? incorrectCount : nil, time)
    }

    func stopGame() {
        timer?.invalidate()
        isGameOver = true
    }

    private func canInput() -> Bool {
        guard !isPaused else { return false }
        switch mode {
        case .timeAttack:
            return timeRemaining > 0
        case .correctCount, .noMistake:
            return !isGameOver
        }
    }

    func enterDigit(_ digit: Int) {
        guard canInput() else { return }
        userInput.append(String(digit))
    }

    func toggleSign() {
        guard canInput() else { return }
        if userInput == "-" {
            userInput = ""
        } else if userInput.hasPrefix("-") {
            userInput.removeFirst()
        } else {
            userInput = "-" + userInput
        }
    }

    func deleteLastDigit() {
        guard canInput() else { return }
        guard !userInput.isEmpty else { return }
        userInput.removeLast()
        if userInput == "-" {
            userInput = ""
        }
    }

    private func clearDeltasAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.scoreDelta = nil
                self.timeDelta = nil
            }
        }
    }

    func submit() {
        guard canInput(), let value = Int(userInput) else { return }

        if value == problem.answer {
            feedback = .correct
            correctCount += 1
            if isSeOn {
                AudioServicesPlaySystemSound(1057)
            }
            if mode == .timeAttack {
                comboCount += 1
                showCombo = comboCount >= 2
                if showCombo {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            self.showCombo = false
                        }
                    }
                }
                withAnimation {
                    score += 10
                    timeRemaining += 2
                    scoreDelta = 10
                    timeDelta = 2
                }
                clearDeltasAfterDelay()
            } else {
                comboCount = 0
                showCombo = false
            }

            answeredCount += 1
            userInput = ""

            if mode == .correctCount && answeredCount >= questionLimit {
                endGame()
                return
            }

            feedback = nil
            problem = ProblemGenerator.generate(difficulty: difficulty, score: score)
        } else {
            feedback = .wrong
            incorrectCount += 1
            comboCount = 0
            showCombo = false
            if isVibrationOn {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
            if mode == .timeAttack {
                withAnimation {
                    score -= 5
                    scoreDelta = -5
                }
                clearDeltasAfterDelay()
            } else if mode == .noMistake {
                endGame()
                userInput = ""
                return
            }

            // Do not change the problem; reset only user input and feedback
            userInput = ""
            feedback = nil
        }
    }

    func pauseGame() {
        timer?.invalidate()
        isPaused = true
    }

    func resumeGame() {
        isPaused = false
        startTimer()
    }
}
