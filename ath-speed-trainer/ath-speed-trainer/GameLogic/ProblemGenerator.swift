import Foundation

/// Generates arithmetic problems based on the selected difficulty, score, and question style.
struct ProblemGenerator {
    static func generate(difficulty: Difficulty, score: Int, style: QuestionStyle) -> ArithmeticProblem {
        switch style {
        case .single:
            return generateSingleProblem(difficulty: difficulty, score: score)
        case .sequence:
            return generateSequenceProblem(difficulty: difficulty, score: score)
        case .mixed:
            return Bool.random()
                ? generateSingleProblem(difficulty: difficulty, score: score)
                : generateSequenceProblem(difficulty: difficulty, score: score)
        }
    }

    // MARK: - Single Operation Problems

    private static func generateSingleProblem(difficulty: Difficulty, score: Int) -> ArithmeticProblem {
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

    // MARK: - Sequence Problems

    private static func generateSequenceProblem(difficulty: Difficulty, score: Int) -> ArithmeticProblem {
        let operations = ["+", "-", "×", "÷"]
        let op1 = operations.randomElement()!
        let op2 = operations.randomElement()!

        var a: Int = 0
        var b: Int = 0
        var c: Int = 0
        var answer: Int = 0

        if precedence(of: op1) >= precedence(of: op2) {
            (a, b) = generateOperands(for: op1, difficulty: difficulty, score: score)
            let firstResult = apply(op1, a, b)
            if op2 == "÷" {
                let range = mulDivRange(for: difficulty, score: score)
                var divisors = Array(range).filter { firstResult % $0 == 0 }
                if divisors.isEmpty { divisors = [1] }
                c = divisors.randomElement()!
            } else {
                c = randomOperand(for: op2, difficulty: difficulty, score: score)
            }
            answer = apply(op2, firstResult, c)
        } else {
            repeat {
                (b, c) = generateOperands(for: op2, difficulty: difficulty, score: score)
                answer = apply(op2, b, c)
            } while op1 == "÷" && answer == 0

            let secondResult = answer
            if op1 == "÷" {
                let range = mulDivRange(for: difficulty, score: score)
                let multiplier = Int.random(in: range)
                a = secondResult * multiplier
                answer = apply(op1, a, secondResult)
            } else {
                a = randomOperand(for: op1, difficulty: difficulty, score: score)
                answer = apply(op1, a, secondResult)
            }
        }

        let question = "\(a) \(op1) \(b) \(op2) \(c)"
        return ArithmeticProblem(question: question, answer: answer)
    }

    // MARK: - Helpers

    private static func addSubRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy: return 1...9
        case .normal: return 10...99
        case .hard: return 100...999
        }
    }

    private static func mulDivRange(for difficulty: Difficulty, score: Int) -> ClosedRange<Int> {
        switch difficulty {
        case .easy, .normal:
            return 1...9
        case .hard:
            return score > 70 ? 10...99 : 1...9
        }
    }

    private static func randomAddSubOperand(difficulty: Difficulty) -> Int {
        Int.random(in: addSubRange(for: difficulty))
    }

    private static func randomMulDivOperand(difficulty: Difficulty, score: Int) -> Int {
        Int.random(in: mulDivRange(for: difficulty, score: score))
    }

    private static func randomOperand(for op: String, difficulty: Difficulty, score: Int) -> Int {
        switch op {
        case "+", "-":
            return randomAddSubOperand(difficulty: difficulty)
        default:
            return randomMulDivOperand(difficulty: difficulty, score: score)
        }
    }

    private static func generateOperands(for op: String, difficulty: Difficulty, score: Int) -> (Int, Int) {
        switch op {
        case "+":
            let a = randomAddSubOperand(difficulty: difficulty)
            let b = randomAddSubOperand(difficulty: difficulty)
            return (a, b)
        case "-":
            let a = randomAddSubOperand(difficulty: difficulty)
            let b = randomAddSubOperand(difficulty: difficulty)
            return (a, b)
        case "×":
            let a = randomMulDivOperand(difficulty: difficulty, score: score)
            let b = randomMulDivOperand(difficulty: difficulty, score: score)
            return (a, b)
        default: // division
            let b = randomMulDivOperand(difficulty: difficulty, score: score)
            let ans = randomMulDivOperand(difficulty: difficulty, score: score)
            let a = b * ans
            return (a, b)
        }
    }

    private static func precedence(of op: String) -> Int {
        (op == "×" || op == "÷") ? 2 : 1
    }

    private static func apply(_ op: String, _ lhs: Int, _ rhs: Int) -> Int {
        switch op {
        case "+": return lhs + rhs
        case "-": return lhs - rhs
        case "×": return lhs * rhs
        default: return lhs / rhs
        }
    }
}

