import Foundation

/// Generates arithmetic problems based on the selected difficulty and current score.
struct ProblemGenerator {
    static func generate(difficulty: Difficulty, score: Int) -> ArithmeticProblem {
        let operations = ["+", "-", "×", "÷"]
        let op = operations.randomElement()!

        switch difficulty {
        case .easy:
            return generateEasyProblem(op: op)
        case .normal:
            return generateNormalProblem(op: op)
        case .hard:
            return generateHardProblem(op: op, score: score)
        }
    }

    // MARK: - Private helpers

    private static func generateEasyProblem(op: String) -> ArithmeticProblem {
        switch op {
        case "+":
            let a = Int.random(in: 1...9)
            let b = Int.random(in: 1...9)
            return ArithmeticProblem(question: "\(a) + \(b)", answer: a + b)
        case "-":
            let a = Int.random(in: 1...9)
            let b = Int.random(in: 1...9)
            return ArithmeticProblem(question: "\(a) - \(b)", answer: a - b)
        case "×":
            let a = Int.random(in: 1...9)
            let b = Int.random(in: 1...9)
            return ArithmeticProblem(question: "\(a) × \(b)", answer: a * b)
        default:
            let b = Int.random(in: 1...9)
            let ans = Int.random(in: 1...9)
            let a = b * ans
            return ArithmeticProblem(question: "\(a) ÷ \(b)", answer: ans)
        }
    }

    private static func generateNormalProblem(op: String) -> ArithmeticProblem {
        switch op {
        case "+":
            let a = Int.random(in: 10...99)
            let b = Int.random(in: 10...99)
            return ArithmeticProblem(question: "\(a) + \(b)", answer: a + b)
        case "-":
            let a = Int.random(in: 10...99)
            let b = Int.random(in: 10...99)
            return ArithmeticProblem(question: "\(a) - \(b)", answer: a - b)
        case "×":
            let a = Int.random(in: 1...9)
            let b = Int.random(in: 1...9)
            return ArithmeticProblem(question: "\(a) × \(b)", answer: a * b)
        default:
            let b = Int.random(in: 1...9)
            let ans = Int.random(in: 1...9)
            let a = b * ans
            return ArithmeticProblem(question: "\(a) ÷ \(b)", answer: ans)
        }
    }

    private static func generateHardProblem(op: String, score: Int) -> ArithmeticProblem {
        switch op {
        case "+":
            let a = Int.random(in: 100...999)
            let b = Int.random(in: 100...999)
            return ArithmeticProblem(question: "\(a) + \(b)", answer: a + b)
        case "-":
            let a = Int.random(in: 100...999)
            let b = Int.random(in: 100...999)
            return ArithmeticProblem(question: "\(a) - \(b)", answer: a - b)
        case "×":
            if score > 70 {
                let a = Int.random(in: 10...99)
                let b = Int.random(in: 10...99)
                return ArithmeticProblem(question: "\(a) × \(b)", answer: a * b)
            } else {
                let a = Int.random(in: 1...9)
                let b = Int.random(in: 1...9)
                return ArithmeticProblem(question: "\(a) × \(b)", answer: a * b)
            }
        default:
            if score > 70 {
                let b = Int.random(in: 10...99)
                let ans = Int.random(in: 10...99)
                let a = b * ans
                return ArithmeticProblem(question: "\(a) ÷ \(b)", answer: ans)
            } else {
                let b = Int.random(in: 1...9)
                let ans = Int.random(in: 1...9)
                let a = b * ans
                return ArithmeticProblem(question: "\(a) ÷ \(b)", answer: ans)
            }
        }
    }
}

