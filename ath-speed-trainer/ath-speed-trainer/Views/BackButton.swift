import SwiftUI

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button("\uFF1C\u623B\u308B", action: action)
                .font(.title3)
            Spacer()
        }
        .padding(.top, 16)
        .padding(.leading, 16)
    }
}

#Preview {
    BackButton {}
}
