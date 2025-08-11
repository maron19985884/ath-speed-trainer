import SwiftUI

struct GameTopBar: View {
    let mode: GameMode
    let score: Int
    let scoreDelta: Int?
    let timeRemaining: Int
    let timeDelta: Int?
    let correctCount: Int
    let onPause: () -> Void

    var body: some View {
        HStack {
            if mode == .timeAttack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Score: \(score)")
                    if let delta = scoreDelta {
                        Text((delta > 0 ? "+\(delta)" : "\(delta)") + "点")
                            .foregroundColor(delta > 0 ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.neonRed)
                    } else {
                        Text(" ")
                            .hidden()
                    }
                }
            } else if mode == .noMistake || mode == .correctCount {
                Text("正解数: \(correctCount)")
            }

            Spacer()

            if mode != .noMistake {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Time: \(timeRemaining)")
                    if let delta = timeDelta {
                        Text((delta > 0 ? "+\(delta)" : "\(delta)") + "秒")
                            .foregroundColor(delta > 0 ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.neonRed)
                    } else {
                        Text(" ")
                            .hidden()
                    }
                }
            }

            Button(action: onPause) {
                Image(systemName: "pause.circle")
                    .font(DesignTokens.Typography.title)
            }
            .accessibilityLabel(Text("一時停止"))
        }
        .font(DesignTokens.Typography.digitalMono)
        .padding(.horizontal, DesignTokens.Spacing.l)
        .padding(.vertical, DesignTokens.Spacing.s)
    }
}

