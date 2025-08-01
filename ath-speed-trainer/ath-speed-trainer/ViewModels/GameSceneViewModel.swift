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
        isGameOver = false
        problem = ProblemGenerator.generate(difficulty: difficulty, score: score)

        switch mode {
        case .timeAttack:
            timeRemaining = 30
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self else { return }
                self.timeRemaining -= 1
                if self.timeRemaining <= 0 {
                    self.endGame()
                }
            }
        case .correctCount, .noMistake:
            timeRemaining = 0
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
        if userInput.hasPrefix("-") {
            userInput.removeFirst()
        } else if !userInput.isEmpty {
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

    func submit() {
        guard canInput() else { return }
        guard let value = Int(userInput) else { return }

        if value == problem.answer {
            feedback = .correct
            correctCount += 1
            AudioServicesPlaySystemSound(1057)
            if mode == .timeAttack {
                score += 10
                timeRemaining += 2
            }
        } else {
            feedback = .wrong
            incorrectCount += 1
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            if mode == .timeAttack {
                score -= 5
            } else if mode == .noMistake {
                endGame()
                userInput = ""
                return
            }
        }

        answeredCount += 1
        userInput = ""

        if mode == .correctCount && answeredCount >= questionLimit {
            endGame()
            return
        }

        if mode == .timeAttack || mode == .correctCount {
            problem = ProblemGenerator.generate(difficulty: difficulty, score: score)
        } else if mode == .noMistake && feedback == .correct {
            problem = ProblemGenerator.generate(difficulty: difficulty, score: score)
        }
    }
}
