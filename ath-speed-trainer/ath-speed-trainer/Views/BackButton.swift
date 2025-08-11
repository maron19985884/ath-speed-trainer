import SwiftUI

struct BackButton: View {
    let title: String
    let action: () -> Void

    init(title: String = "モード選択に戻る", action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        HStack {
            Button(action: {
                SEManager.shared.play(.button)
                action()
            }) {
                HStack(spacing: DesignTokens.Spacing.s) {
                    Image(systemName: "chevron.left.circle.fill")
                        .foregroundColor(DesignTokens.Colors.neonBlue)
                    Text(title)
                        .foregroundColor(DesignTokens.Colors.onDark)
                }
                .font(DesignTokens.Typography.body)
                .padding(DesignTokens.Spacing.s)
                .background(DesignTokens.Colors.surface)
                .cornerRadius(DesignTokens.Radius.m)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.m)
                        .stroke(DesignTokens.Colors.neonBlue, lineWidth: 1)
                )
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
