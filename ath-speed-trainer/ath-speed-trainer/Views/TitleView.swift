import SwiftUI

struct TitleView: View {
    @Binding var currentScreen: AppScreen
    @State private var blink = false   // 点滅状態管理

    var body: some View {
        ZStack {
            Image("title_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            Text("Tap to Start")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white.opacity(0.85))
                .opacity(blink ? 0.2 : 1.0) // 透明度を切り替え
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                        blink.toggle()
                    }
                }
        }
        .contentShape(Rectangle())
        .onTapGesture {
        
            currentScreen = .modeSelect
        }
    }
}

#Preview {
    TitleView(currentScreen: .constant(.title))
}
