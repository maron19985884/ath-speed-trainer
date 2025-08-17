import SwiftUI

struct GameTopBar: View {
    let mode: GameMode
    let score: Int
    let scoreDelta: Int?
    let timeRemaining: Int
    let timeDelta: Int?
    let correctCount: Int
    let onPause: () -> Void

    private let rowHeight: CGFloat = 44

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.s) {
            // 上段：一時停止（右寄せ）
            HStack {
                Spacer()
                Button(action: onPause) {
                    Image(systemName: "pause.circle")
                        .font(DesignTokens.Typography.title)
                }
                .accessibilityLabel(Text("一時停止"))
            }
            .frame(height: rowHeight)

            // 下段：左=スコア（timeAttackのみ）、右=モード別表示
            HStack {
                // 左側：timeAttackのみスコア表示
                if mode == .timeAttack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Score: \(score)")
                        if let delta = scoreDelta {
                            Text((delta > 0 ? "+\(delta)" : "\(delta)") + "点")
                                .foregroundColor(delta > 0 ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.neonRed)
                        } else {
                            Text(" ").hidden()
                        }
                    }
                } else {
                    Spacer(minLength: 0)
                }

                Spacer()

                // 右側：モード別に出し分け
                VStack(alignment: .trailing, spacing: 2) {
                    switch mode {
                    case .correctCount:
                        // 10問正解スピード：Timeのみ
                        Text("Time: \(timeRemaining)")
                        if let d = timeDelta {
                            Text((d > 0 ? "+\(d)" : "\(d)") + "秒")
                                .foregroundColor(d > 0 ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.neonRed)
                        } else {
                            Text(" ").hidden()
                        }

                    case .noMistake:
                        // ミス耐久：正解数のみ
                        Text("正解数: \(correctCount)")
                        Text(" ").hidden() // 高さ合わせ

                    default:
                        // その他（例：timeAttack）もTimeを表示
                        Text("Time: \(timeRemaining)")
                        if let d = timeDelta {
                            Text((d > 0 ? "+\(d)" : "\(d)") + "秒")
                                .foregroundColor(d > 0 ? DesignTokens.Colors.neonGreen : DesignTokens.Colors.neonRed)
                        } else {
                            Text(" ").hidden()
                        }
                    }
                }
            }
            .frame(height: rowHeight * 1.5) // 2行想定で余裕を持たせる
        }
        .padding(.horizontal, DesignTokens.Spacing.l)
        .padding(.bottom, DesignTokens.Spacing.s)
        .font(DesignTokens.Typography.digitalMono)
        .monospacedDigit()
        .lineLimit(1)
    }
}
