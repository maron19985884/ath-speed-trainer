import SwiftUI

struct CreditView: View {
    @Binding var currentScreen: AppScreen

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
            HStack {
                Button(action: { currentScreen = .modeSelect }) {
                    Text("メニューに戻る")
                        .font(DesignTokens.Typography.body)
                        .padding(DesignTokens.Spacing.s)
                        .background(DesignTokens.Colors.surface)
                        .cornerRadius(DesignTokens.Radius.m)
                        .foregroundColor(DesignTokens.Colors.onDark)
                }
                .contentShape(Rectangle())
                Spacer()
            }
            .padding(.top, DesignTokens.Spacing.l)
            .padding(.leading, DesignTokens.Spacing.l)

            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.l) {
                    Text("Ath Speed Trainer")
                        .font(DesignTokens.Typography.title)

                    Group {
                        Text("開発者")
                            .font(DesignTokens.Typography.body).bold()
                        Text("Keita Kobayashi")
                            .font(DesignTokens.Typography.body)
                    }

                    Group {
                        Text("使用素材")
                            .font(DesignTokens.Typography.body).bold()
                        Text("アイコン：Flaticon\n効果音：効果音ラボ")
                            .font(DesignTokens.Typography.body)
                            .multilineTextAlignment(.leading)
                    }

                    Group {
                        Text("ライセンス")
                            .font(DesignTokens.Typography.body).bold()
                        Text("このアプリはMITライセンスに基づいて公開されています。\n使用素材の著作権は各提供元に帰属します。")
                            .font(DesignTokens.Typography.body)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
                .padding(.bottom, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            }
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .background(DesignTokens.Colors.backgroundDark.ignoresSafeArea())
    }
}

#Preview {
    CreditView(currentScreen: .constant(AppScreen.modeSelect))
}

