import Foundation

struct AdConfig {
    static let isAdsEnabled = true

    #if DEBUG
    // Googleのテスト用ID
    static let appID = "ca-app-pub-3940256099942544~1458002511"
    static let bannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let interstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
    static let nativeUnitID = "ca-app-pub-3940256099942544/3986624511"
    #else
    // ★本番用（あなたのAdMob発行ID）
    static let appID = "ca-app-pub-4060136684986886~5257841666"
    static let bannerUnitID = "ca-app-pub-4060136684986886/5313681984"
    static let interstitialUnitID = "ca-app-pub-4060136684986886/3823155274"
    static let nativeUnitID = "ca-app-pub-4060136684986886/6390411195"
    #endif

    /// インタースティシャルを何回に1回出すか（例: 3 = 3回に1回）
    static let frequencyN = 2
}
