import SwiftUI

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                Text("＜戻る") // ← 直接文字列で記述
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
    }
}

#Preview {
    BackButton {}
}
