import SwiftUI
import AVFoundation

struct GameScene: View {
    @StateObject private var viewModel = GameSceneViewModel()

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Score: \(viewModel.score)")
                Spacer()
                Text("Time: \(viewModel.timeRemaining)")
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
        .onAppear { viewModel.startGame() }
    }

    private var keypad: some View {
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
                    }
                }
            }
            HStack(spacing: 10) {
                Button(action: { viewModel.enterDigit(0) }) {
                    Text("0")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                Button("Enter") { viewModel.submit() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: 200)
    }
}

#Preview {
    GameScene()
}
