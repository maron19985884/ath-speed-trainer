import SwiftUI

struct TitleView: View {
    @Binding var currentScreen: AppScreen

    var body: some View {
        ZStack {
            Image("title_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Text("Tap to Start")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .contentShape(Rectangle())
        .onTapGesture { currentScreen = .modeSelect }
    }
}

#Preview {
    TitleView(currentScreen: .constant(.title))
}
