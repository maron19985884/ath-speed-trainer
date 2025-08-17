import SwiftUI

struct SettingView: View {
    @Binding var currentScreen: AppScreen
    @AppStorage("isSeOn") private var isSeOn: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
            BackButton { currentScreen = .modeSelect }

            VStack(alignment: .leading, spacing: DesignTokens.Spacing.l) {
                Text("設定")
                    .font(DesignTokens.Typography.title)
                    .underline(true, color: DesignTokens.Colors.neonBlue)

                VStack(spacing: DesignTokens.Spacing.m) {
                    Toggle("効果音（SE）", isOn: $isSeOn)
                        .padding()
                        .background(DesignTokens.Colors.surface)
                        .cornerRadius(DesignTokens.Radius.m)
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                                .stroke(DesignTokens.Colors.neonBlue, lineWidth: 1)
                        )
                }
            }

            Spacer()
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .padding(.vertical, DesignTokens.Spacing.xl)
        .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
        .appBackground()
        .safeAreaInset(edge: .bottom) {
            AdBannerView()
                .padding(.top, 8)
        }
    }
}

#Preview {
    SettingView(currentScreen: .constant(AppScreen.modeSelect))
}
