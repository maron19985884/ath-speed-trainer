import SwiftUI

struct SettingView: View {
    @Binding var currentScreen: AppScreen
    @AppStorage("isBgmOn") private var isBgmOn: Bool = true
    @AppStorage("isSeOn") private var isSeOn: Bool = true

    var body: some View {
        VStack(spacing: 20) {
            BackButton { currentScreen = .modeSelect }

            VStack(spacing: 40) {
                Text("設定")
                    .font(.largeTitle)

                VStack(spacing: 20) {
                    Toggle("BGM", isOn: $isBgmOn)
                        .font(.title2)
                    Toggle("効果音（SE）", isOn: $isSeOn)
                        .font(.title2)
                }
                .padding(.horizontal, 40)
            }

            Spacer()
        }
    }
}

#Preview {
    SettingView(currentScreen: .constant(AppScreen.modeSelect))
}
