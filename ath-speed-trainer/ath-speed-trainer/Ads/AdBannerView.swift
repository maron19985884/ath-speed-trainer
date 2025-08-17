import SwiftUI
import GoogleMobileAds

struct AdBannerView: View {
    @State private var height: CGFloat? = nil

    var body: some View {
        if AdConfig.isAdsEnabled {
            BannerContainer(height: $height)
                .frame(height: height)
        }
    }

    private struct BannerContainer: UIViewRepresentable {
        @Binding var height: CGFloat?

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func makeUIView(context: Context) -> GADBannerView {
            let size = UIDevice.current.userInterfaceIdiom == .pad ? GADAdSizeLargeBanner : GADAdSizeBanner
            let view = GADBannerView(adSize: size)
            view.adUnitID = AdConfig.bannerUnitID
            view.rootViewController = UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.windows.first { $0.isKeyWindow } }
                .first?.rootViewController
            view.delegate = context.coordinator
            view.load(GADRequest())
            return view
        }

        func updateUIView(_ uiView: GADBannerView, context: Context) {}

        final class Coordinator: NSObject, GADBannerViewDelegate {
            private let parent: BannerContainer
            init(_ parent: BannerContainer) {
                self.parent = parent
            }

            func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
                parent.height = bannerView.bounds.height
                #if DEBUG
                print("Banner loaded")
                #endif
            }

            func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
                parent.height = 0
                #if DEBUG
                print("Banner failed: \(error.localizedDescription)")
                #endif
            }
        }
    }
}
