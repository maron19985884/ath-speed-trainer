import SwiftUI
import GoogleMobileAds
import UIKit

/// 画面最下部のバナー。初期から想定高さを確保しておく＝ロード後にレイアウトが動かない。
struct AdBannerView: View {
    /// No fill 時に席を畳むか（既定は畳まない＝席保持）
    var collapseWhenNoFill: Bool = false

    @Environment(\.scenePhase) private var scenePhase
    @State private var reservedHeight: CGFloat = 0   // 予約（想定）高さ
    @State private var actualHeight: CGFloat = 0     // 実高さ（ロード後に更新）

    var body: some View {
        if !AdConfig.isAdsEnabled {
            EmptyView()
        } else {
            GeometryReader { geo in
                let width = max(1, geo.size.width)

                BannerContainer(
                    width: width,
                    collapseWhenNoFill: collapseWhenNoFill,
                    reservedHeight: $reservedHeight,
                    actualHeight: $actualHeight
                )
                .frame(maxWidth: .infinity)
                .frame(height: max(reservedHeight, actualHeight))
                .onAppear {
                    // 初回に想定高さを予約
                    let size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
                    reservedHeight = size.size.height
                }
                .onChange(of: geo.size.width) { newWidth in
                    // 回転などで幅が変わったら予約高を再計算
                    let size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(max(1, newWidth))
                    reservedHeight = size.size.height
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .active {
                        let size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
                        reservedHeight = size.size.height
                    }
                }
            }
            .frame(height: max(reservedHeight, actualHeight)) // 親にも同じ高さを反映
        }
    }

    // MARK: - UIKit ラッパー
    private struct BannerContainer: UIViewRepresentable {
        let width: CGFloat
        let collapseWhenNoFill: Bool
        @Binding var reservedHeight: CGFloat
        @Binding var actualHeight: CGFloat

        func makeCoordinator() -> Coordinator { Coordinator(self) }

        func makeUIView(context: Context) -> GADBannerView {
            let size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
            let banner = GADBannerView(adSize: size)
            banner.backgroundColor = .clear
            banner.adUnitID = AdConfig.bannerUnitID
            banner.rootViewController = UIApplication.shared.connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
                .first
            banner.delegate = context.coordinator
            banner.load(GADRequest())
            return banner
        }

        func updateUIView(_ uiView: GADBannerView, context: Context) {
            // 幅変更に追従（必要なときだけリロード）
            let size = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
            if uiView.adSize.size.width != size.size.width {
                uiView.adSize = size
                uiView.load(GADRequest())
            }
        }

        final class Coordinator: NSObject, GADBannerViewDelegate {
            private let parent: BannerContainer
            init(_ parent: BannerContainer) { self.parent = parent }

            func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
                parent.actualHeight = bannerView.bounds.height
                #if DEBUG
                print("[AdBanner] loaded: \(parent.actualHeight)pt (reserved: \(parent.reservedHeight)pt)")
                #endif
            }

            func bannerView(_ bannerView: GADBannerView,
                            didFailToReceiveAdWithError error: Error) {
                #if DEBUG
                print("[AdBanner] failed: \(error.localizedDescription)")
                #endif
                // 既定は“席を保持してレイアウトを動かさない”
                if parent.collapseWhenNoFill {
                    parent.actualHeight = 0
                    parent.reservedHeight = 0
                } else {
                    parent.actualHeight = 0
                }
            }
        }
    }
}

// MARK: - Helpers
private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } }
}
