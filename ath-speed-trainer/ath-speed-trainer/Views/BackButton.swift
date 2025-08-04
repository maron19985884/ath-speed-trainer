import SwiftUI

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                Text("＜戻る") // ← 直接文字列で記述
                    .font(.title3)
                    .padding(8)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .contentShape(Rectangle())
            Spacer()
        }
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}

#Preview {
    BackButton {}
}
