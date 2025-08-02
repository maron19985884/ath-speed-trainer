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

    enum Feedback { case correct, wrong }

    private let difficulty: Difficulty
    private var timer: Timer?
    private let onGameEnd: ((Int, Int, Int) -> Void)?

    init(difficulty: Difficulty, onGameEnd: ((Int, Int, Int) -> Void)? = nil) {
        self.difficulty = difficulty
        self.onGameEnd = onGameEnd
        self.problem = ProblemGenerator.generate(difficulty: difficulty, score: 0)
    }

    func startGame() {
        timer?.invalidate()
        timeRemaining = 30
        score = 0
        userInput = ""
        feedback = nil
        correctCount = 0
        incorrectCount = 0
        problem = ProblemGenerator.generate(difficulty: difficulty, score: score)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.onGameEnd?(self.score, self.correctCount, self.incorrectCount)
            }
        }
    }

    func stopGame() {
        timer?.invalidate()
    }

    func enterDigit(_ digit: Int) {
        guard timeRemaining > 0 else { return }
        userInput.append(String(digit))
    }

    func toggleSign() {
        guard timeRemaining > 0 else { return }
        if userInput.hasPrefix("-") {
            userInput.removeFirst()
        } else if !userInput.isEmpty {
            userInput = "-" + userInput
        }
    }

    func deleteLastDigit() {
        guard timeRemaining > 0 else { return }
        guard !userInput.isEmpty else { return }
        userInput.removeLast()
        if userInput == "-" {
            userInput = ""
        }
    }

    func submit() {
        guard timeRemaining > 0 else { return }
        guard let value = Int(userInput) else { return }
        if value == problem.answer {
            score += 10
            timeRemaining += 2
            feedback = .correct
            correctCount += 1
            AudioServicesPlaySystemSound(1057)
            problem = ProblemGenerator.generate(difficulty: difficulty, score: score)
            userInput = ""
        } else {
            score -= 5
            feedback = .wrong
            incorrectCount += 1
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            userInput = ""
        }
    }
}
