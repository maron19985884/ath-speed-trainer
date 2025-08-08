import SwiftUI

struct SettingView: View {
    @Binding var currentScreen: AppScreen
    @AppStorage("isBgmOn") private var isBgmOn: Bool = true
    @AppStorage("isSeOn") private var isSeOn: Bool = true
    @AppStorage("isVibrationOn") private var isVibrationOn: Bool = true

    var body: some View {
        VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
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


            VStack(spacing: DesignTokens.Spacing.l + DesignTokens.Spacing.xl) {
                Text("設定")
                    .font(DesignTokens.Typography.title)

                VStack(spacing: DesignTokens.Spacing.m + DesignTokens.Spacing.s) {
                    Toggle("BGM", isOn: $isBgmOn)
                        .font(DesignTokens.Typography.title)
                    Toggle("効果音（SE）", isOn: $isSeOn)
                        .font(DesignTokens.Typography.title)
                    Toggle("バイブレーション", isOn: $isVibrationOn)
                        .font(DesignTokens.Typography.title)
                }
                .padding(.horizontal, DesignTokens.Spacing.l + DesignTokens.Spacing.xl)
            }

            Spacer()
        }
        .foregroundColor(DesignTokens.Colors.onDark)
        .background(DesignTokens.Colors.backgroundDark.ignoresSafeArea())
    }
}

#Preview {
    SettingView(currentScreen: .constant(AppScreen.modeSelect))
}
