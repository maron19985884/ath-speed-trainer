import SwiftUI
import AVFoundation

final class GameSceneViewModel: ObservableObject {
    @Published var problem: ArithmeticProblem = ProblemGenerator.generate()
    @Published var userInput: String = ""
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 30
    @Published var feedback: Feedback? = nil

    enum Feedback { case correct, wrong }

    private var timer: Timer?

    func startGame() {
        timer?.invalidate()
        timeRemaining = 30
        score = 0
        userInput = ""
        feedback = nil
        problem = ProblemGenerator.generate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
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

    func submit() {
        guard timeRemaining > 0 else { return }
        guard let value = Int(userInput) else { return }
        if value == problem.answer {
            score += 10
            timeRemaining += 2
            feedback = .correct
            AudioServicesPlaySystemSound(1057)
            problem = ProblemGenerator.generate()
            userInput = ""
        } else {
            score -= 5
            feedback = .wrong
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            userInput = ""
        }
    }
}
