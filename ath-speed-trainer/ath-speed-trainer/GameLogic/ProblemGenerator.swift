import Foundation

struct ProblemGenerator {
    static func generate() -> ArithmeticProblem {
        let operations = ["+", "-", "×", "÷"]
        let op = operations.randomElement()!
        switch op {
        case "+":
            let a = Int.random(in: 1...99)
            let b = Int.random(in: 1...99)
            return ArithmeticProblem(question: "\(a) + \(b)", answer: a + b)
        case "-":
            let a = Int.random(in: 1...99)
            let b = Int.random(in: 1...99)
            return ArithmeticProblem(question: "\(a) - \(b)", answer: a - b)
        case "×":
            let a = Int.random(in: 1...99)
            let b = Int.random(in: 1...99)
            return ArithmeticProblem(question: "\(a) × \(b)", answer: a * b)
        default:
            let b = Int.random(in: 1...9)
            let ans = Int.random(in: 1...9)
            let a = b * ans
            return ArithmeticProblem(question: "\(a) ÷ \(b)", answer: ans)
        }
    }
}
