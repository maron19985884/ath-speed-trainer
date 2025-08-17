import SwiftUI

struct CreditView: View {
    @Binding var currentScreen: AppScreen

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
            BackButton { currentScreen = .modeSelect }

            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.l) {
                    Text("計算スピードゲーム")
                        .font(DesignTokens.Typography.title)
                        .glow(DesignTokens.Colors.neonBlue)

                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.s) {
                        Text("開発者")
                            .font(DesignTokens.Typography.body).bold()
                        Text("Keita Kobayashi")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.onMuted)
                    }
                    .padding()
                    .background(DesignTokens.Colors.surface)
                    .cornerRadius(DesignTokens.Radius.m)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                            .stroke(DesignTokens.Colors.neonBlue, lineWidth: 1)
                    )

                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.s) {
                        Text("ライセンス")
                            .font(DesignTokens.Typography.body).bold()
                        Text("このアプリはMITライセンスに基づいて公開されています。\n使用素材の著作権は各提供元に帰属します。")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.onMuted)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background(DesignTokens.Colors.surface)
                    .cornerRadius(DesignTokens.Radius.m)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                            .stroke(DesignTokens.Colors.neonBlue, lineWidth: 1)
                    )
                }
                .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
                .padding(.vertical, DesignTokens.Spacing.xl)
            }
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .appBackground()
        .safeAreaInset(edge: .bottom) {
            AdBannerView()
                .padding(.top, 8)
        }
    }
}

#Preview {
    CreditView(currentScreen: .constant(AppScreen.modeSelect))
}

