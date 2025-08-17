import Foundation

struct AdConfig {
    static let isAdsEnabled = true

    #if DEBUG
    static let appID = "ca-app-pub-3940256099942544~1458002511"
    static let bannerUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let interstitialUnitID = "ca-app-pub-3940256099942544/4411468910"
    #else
    static let appID = "ca-app-pub-XXXXXXXX~YYYYYYYY"
    static let bannerUnitID = "ca-app-pub-XXXXXXXX/BBBBBBBB"
    static let interstitialUnitID = "ca-app-pub-XXXXXXXX/IIIIIIII"
    #endif

    static let frequencyN = 3
}
