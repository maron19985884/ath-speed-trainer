import GoogleMobileAds
import UIKit

final class InterstitialAdCoordinator: NSObject, GADFullScreenContentDelegate {
    static let shared = InterstitialAdCoordinator()

    private var interstitial: GADInterstitialAd?
    private var hitCount = 0
    private var displayedLastTime = false
    private var completion: (() -> Void)?

    func preload() {
        guard AdConfig.isAdsEnabled else { return }
        #if DEBUG
        print("Interstitial preload")
        #endif
        GADInterstitialAd.load(withAdUnitID: AdConfig.interstitialUnitID, request: AdRequestFactory.make()) { [weak self] ad, error in
            guard let self else { return }
            if let ad = ad {
                self.interstitial = ad
                ad.fullScreenContentDelegate = self
                #if DEBUG
                print("Interstitial loaded")
                #endif
            } else {
                #if DEBUG
                print("Interstitial failed: \(error?.localizedDescription ?? "unknown error")")
                #endif
            }
        }
    }

    func show(from rootViewController: UIViewController?, completion: @escaping () -> Void) {
        guard AdConfig.isAdsEnabled else {
            completion()
            return
        }

        if displayedLastTime {
            displayedLastTime = false
            completion()
            return
        }

        hitCount += 1
        guard hitCount % AdConfig.frequencyN == 0,
              let interstitial = interstitial,
              let rootViewController = rootViewController else {
            completion()
            return
        }

        self.completion = completion
        #if DEBUG
        print("Interstitial present")
        #endif
        interstitial.present(fromRootViewController: rootViewController)
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        displayedLastTime = true
        completion?()
        completion = nil
        interstitial = nil
        preload()
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        #if DEBUG
        print("Interstitial presentation failed: \(error.localizedDescription)")
        #endif
        completion?()
        completion = nil
        interstitial = nil
        displayedLastTime = false
        preload()
    }
}
