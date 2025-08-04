import SwiftUI

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                Text("\uFF1C\u623B\u308B")
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
