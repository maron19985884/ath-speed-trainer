import SwiftUI
import AVFoundation

// MARK: - Button Styles

private struct CyberKeypadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .frame(minWidth: 56, minHeight: 56)
            .background(DesignTokens.Colors.surface)
            .foregroundColor(DesignTokens.Colors.onDark)
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                    .stroke(DesignTokens.Colors.neonBlue.opacity(0.6), lineWidth: 1)
            )
            .cornerRadius(DesignTokens.Radius.m)
            .keycapShadow()
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .glow(
                DesignTokens.Colors.neonBlue,
                radius: configuration.isPressed ? 8 : 0
            )
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

private struct CyberEnterButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 56)
            .foregroundColor(DesignTokens.Colors.onDark)
            .background(
                LinearGradient(
                    colors: [DesignTokens.Colors.neonBlue, DesignTokens.Colors.neonBlueDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                    .stroke(DesignTokens.Colors.neonBlue.opacity(0.6), lineWidth: 1)
            )
            .cornerRadius(DesignTokens.Radius.m)
            .keycapShadow()
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .glow(
                DesignTokens.Colors.neonBlue,
                radius: configuration.isPressed ? 8 : 0
            )
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct GameScene: View {
    @Binding var currentScreen: AppScreen
    private let mode: GameMode
    @StateObject private var viewModel: GameSceneViewModel
    @State private var showPauseMenu = false
    @State private var countdown: Int = 0

    init(difficulty: Difficulty, mode: GameMode, style: QuestionStyle, currentScreen: Binding<AppScreen>, onGameEnd: @escaping (Int, Int, Int?, Int) -> Void) {
        _viewModel = StateObject(wrappedValue: GameSceneViewModel(difficulty: difficulty, mode: mode, style: style, onGameEnd: onGameEnd))
        self.mode = mode
        self._currentScreen = currentScreen
    }

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.isLandscape

            ZStack {
                VStack(spacing: 0) {
                    GameTopBar(
                        mode: mode,
                        score: viewModel.score,
                        scoreDelta: viewModel.scoreDelta,
                        timeRemaining: viewModel.timeRemaining,
                        timeDelta: viewModel.timeDelta,
                        correctCount: viewModel.correctCount,
                        onPause: {
                            viewModel.pauseGame()
                            showPauseMenu = true
                        }
                    )

                    if isLandscape {
                        HStack(alignment: .center, spacing: DesignTokens.Spacing.l) {
                            VStack(spacing: DesignTokens.Spacing.m) {
                                problemSection
                                Text(viewModel.userInput)
                                    .font(.system(size: 28, weight: .semibold, design: .monospaced))
                                    .frame(height: 40)
                                Spacer(minLength: 0)
                            }
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                            .padding(DesignTokens.Spacing.l)

                            VStack {
                                keypad
                                    .frame(maxWidth: 320)
                            }
                            .padding(DesignTokens.Spacing.l)
                        }
                    } else {
                        VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                            problemSection
                            Text(viewModel.userInput)
                                .font(.system(size: 28, weight: .semibold, design: .monospaced))
                                .frame(height: 40)
                            keypad
                                .frame(maxWidth: 280)
                        }
                        .padding(DesignTokens.Spacing.l)
                    }
                }

                overlaysSection
            }
            .foregroundColor(DesignTokens.Colors.onDark)
            .appBackground()
            .animation(.easeInOut, value: viewModel.comboCount)
            .onAppear { viewModel.startGame() }
        }
    }

    private var feedbackIconSection: some View {
        Group {
            if let feedback = viewModel.feedback {
                Image(systemName: feedback == .correct ? "checkmark.seal.fill" : "xmark.octagon.fill")
                    .foregroundColor(feedback == .correct ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.neonRed)
                    .glow(feedback == .correct ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.neonRed)
            } else {
                Image(systemName: "checkmark.circle")
                    .opacity(0)
            }
        }
        .font(DesignTokens.Typography.digitalMono)
    }

    private var problemSection: some View {
        VStack(spacing: DesignTokens.Spacing.s) {
            Text(viewModel.problem.question)
                .font(.system(size: 36, weight: .bold))
                .glow(DesignTokens.Colors.neonBlue, radius: 10)
            feedbackIconSection
                .frame(height: 60)
        }
    }

    private var overlaysSection: some View {
        ZStack {
            if showPauseMenu {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    Button("再開") {
                        startCountdown {
                            viewModel.resumeGame()
                        }
                    }
                    .font(DesignTokens.Typography.title)
                    .padding(DesignTokens.Spacing.m)
                    .background(DesignTokens.Colors.surface)
                    .cornerRadius(DesignTokens.Radius.m)
                    .foregroundColor(DesignTokens.Colors.onDark)

                    Button("リセット") {
                        startCountdown {
                            viewModel.startGame()
                        }
                    }
                    .font(DesignTokens.Typography.title)
                    .padding(DesignTokens.Spacing.m)
                    .background(DesignTokens.Colors.surface)
                    .cornerRadius(DesignTokens.Radius.m)
                    .foregroundColor(DesignTokens.Colors.onDark)

                    Button("モード選択に戻る") {
                        viewModel.stopGame()
                        currentScreen = .modeSelect
                    }
                    .font(DesignTokens.Typography.title)
                    .padding(DesignTokens.Spacing.m)
                    .background(DesignTokens.Colors.surface)
                    .cornerRadius(DesignTokens.Radius.m)
                    .foregroundColor(DesignTokens.Colors.onDark)
                }
                .padding(DesignTokens.Spacing.m)
                .background(DesignTokens.Colors.surface)
                .cornerRadius(DesignTokens.Radius.m)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                        .stroke(DesignTokens.Colors.neonBlue.opacity(0.6), lineWidth: 1)
                )
            }

            if countdown > 0 {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                Text("\(countdown)")
                    .font(DesignTokens.Typography.digitalMono)
                    .scaleEffect(2)
                    .foregroundColor(DesignTokens.Colors.neonPurple)
                    .glow(DesignTokens.Colors.neonPurple)
            }

            VStack {
                if viewModel.showCombo {
                    Text("連続\(viewModel.comboCount)問正解！")
                        .font(DesignTokens.Typography.title)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .padding(.horizontal, DesignTokens.Spacing.l)
                        .padding(.vertical, DesignTokens.Spacing.s)
                        .background(DesignTokens.Colors.surface)
                        .cornerRadius(DesignTokens.Radius.m)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                                .stroke(DesignTokens.Colors.neonBlue.opacity(0.5), lineWidth: 1)
                        )
                        .glow(DesignTokens.Colors.neonBlue.opacity(0.4), radius: 6)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, DesignTokens.Spacing.xl * 3)
            .allowsHitTesting(false)
            .zIndex(2)
            .animation(.easeInOut, value: viewModel.showCombo)
        }
    }

    private var keypad: some View {
        VStack(spacing: DesignTokens.Spacing.s) {
            VStack(spacing: DesignTokens.Spacing.s) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: DesignTokens.Spacing.s) {
                        ForEach(1...3, id: \.self) { col in
                            let number = row * 3 + col
                            Button(action: { viewModel.enterDigit(number) }) {
                                Text("\(number)")
                            }
                            .buttonStyle(CyberKeypadButtonStyle())
                            .accessibilityLabel(Text("数字\(number)"))
                        }
                    }
                }
                HStack(spacing: DesignTokens.Spacing.s) {
                    Button(action: { viewModel.toggleSign() }) {
                        Text("+/-")
                    }
                    .buttonStyle(CyberKeypadButtonStyle())
                    .accessibilityLabel(Text("符号切替"))

                    Button(action: { viewModel.enterDigit(0) }) {
                        Text("0")
                    }
                    .buttonStyle(CyberKeypadButtonStyle())
                    .accessibilityLabel(Text("数字0"))

                    Button(action: { viewModel.deleteLastDigit() }) {
                        Image(systemName: "delete.left")
                    }
                    .buttonStyle(CyberKeypadButtonStyle())
                    .accessibilityLabel(Text("削除"))
                }
            }

            Button(action: { viewModel.submit() }) {
                Text("ENTER")
            }
            .buttonStyle(CyberEnterButtonStyle())
            .contentShape(Rectangle())
            .disabled(viewModel.userInput.isEmpty)
            .opacity(viewModel.userInput.isEmpty ? 0.4 : 1.0)
            .accessibilityLabel(Text("決定"))

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
    GameScene(difficulty: .easy, mode: .timeAttack, style: .single, currentScreen: .constant(.game), onGameEnd: { _,_,_,_ in })
}
