import SwiftUI
import GoogleMobileAds

/// Square native ad container that reserves its space from initial layout.
struct NativeSquareAdView: View {
    @StateObject private var loader = NativeAdLoader()

    private var side: CGFloat {
        let minSide = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return min(max(minSide * 0.8, 300), 360)
    }

    var body: some View {
        ZStack {
            if let ad = loader.nativeAd, hasMedia(ad) {
                NativeAdView(ad: ad)
            } else {
                placeholder
            }
        }
        .frame(width: side, height: side)
    }

    private func hasMedia(_ ad: GADNativeAd) -> Bool {
        if ad.mediaContent.aspectRatio > 0 { return true }
        if let images = ad.images, !images.isEmpty { return true }
        return false
    }

    private var placeholder: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(DesignTokens.Colors.onMuted.opacity(0.2), lineWidth: 1)
            .overlay(
                Text("広告")
                    .font(.caption2)
                    .foregroundColor(DesignTokens.Colors.onMuted)
                    .padding(4)
                    .background(DesignTokens.Colors.surface.opacity(0.6))
                    .cornerRadius(4),
                alignment: .bottomLeading
            )
    }
}

// MARK: - UIKit wrapper
private struct NativeAdView: UIViewRepresentable {
    let ad: GADNativeAd

    func makeUIView(context: Context) -> GADNativeAdView {
        let view = GADNativeAdView(frame: .zero)

        // Media view (square)
        let mediaView = GADMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        view.mediaView = mediaView
        view.addSubview(mediaView)

        // Headline label
        let headline = UILabel()
        headline.translatesAutoresizingMaskIntoConstraints = false
        headline.font = .systemFont(ofSize: 12)
        headline.textColor = UIColor.white.withAlphaComponent(0.7)
        view.headlineView = headline
        mediaView.addSubview(headline)

        // Ad badge
        let badge = UILabel()
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.text = "広告"
        badge.font = .systemFont(ofSize: 10, weight: .semibold)
        badge.textColor = UIColor.white.withAlphaComponent(0.7)
        badge.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        badge.layer.cornerRadius = 3
        badge.clipsToBounds = true
        mediaView.addSubview(badge)

        view.callToActionView = nil

        // Layout constraints
        NSLayoutConstraint.activate([
            mediaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mediaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mediaView.topAnchor.constraint(equalTo: view.topAnchor),
            mediaView.heightAnchor.constraint(equalTo: mediaView.widthAnchor),

            headline.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor, constant: 4),
            headline.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: -4),

            badge.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor, constant: -4),
            badge.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: -4)
        ])

        view.nativeAd = ad
        headline.text = ad.headline
        mediaView.mediaContent = ad.mediaContent

        return view
    }

    func updateUIView(_ uiView: GADNativeAdView, context: Context) {
        uiView.nativeAd = ad
        (uiView.headlineView as? UILabel)?.text = ad.headline
        uiView.mediaView?.mediaContent = ad.mediaContent
    }
}

