import Foundation
import GoogleMobileAds
import UIKit

/// Native ad loader that keeps a reserved spot regardless of load success.
final class NativeAdLoader: NSObject, ObservableObject, GADNativeAdLoaderDelegate {
    @Published var nativeAd: GADNativeAd?

    private var adLoader: GADAdLoader?
    private var isLoading = false

    override init() {
        super.init()
        loadAd()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reload),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func reload() {
        loadAd()
    }

    /// Requests a new native ad if one isn't already being loaded.
    func loadAd() {
        guard !isLoading else { return }
        isLoading = true

        let options = GADNativeAdImageAdLoaderOptions()
        options.shouldRequestMultipleImages = false

        let loader = GADAdLoader(adUnitID: AdConfig.nativeUnitID,
                                 rootViewController: nil,
                                 adTypes: [.native],
                                 options: [options])
        loader.delegate = self
        loader.load(AdRequestFactory.make())
        adLoader = loader

        #if DEBUG
        print("[NativeAd] load requested")
        #endif
    }

    // MARK: - GADNativeAdLoaderDelegate
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        #if DEBUG
        print("[NativeAd] loaded")
        #endif
        DispatchQueue.main.async {
            self.nativeAd = nativeAd
            self.isLoading = false
        }
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        #if DEBUG
        print("[NativeAd] failed: \(error.localizedDescription)")
        #endif
        DispatchQueue.main.async {
            self.nativeAd = nil
            self.isLoading = false
        }
    }
}

