import Foundation

struct AdConfig {
    static let isAdsEnabled = true


    // ★本番用（あなたのAdMob発行ID）
    static let appID = "ca-app-pub-4060136684986886~5257841666"
    static let bannerUnitID = "ca-app-pub-4060136684986886/5313681984"
    static let interstitialUnitID = "ca-app-pub-4060136684986886/3823155274"
    static let nativeUnitID = "ca-app-pub-4060136684986886/6390411195"


    /// インタースティシャルを何回に1回出すか（例: 3 = 3回に1回）
    static let frequencyN = 2

    /// Cached tracking status key
    static let trackingStatusKey = "trackingAuthorizationStatus"
}
