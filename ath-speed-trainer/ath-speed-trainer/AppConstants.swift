import Foundation

struct AppConstants {
    #if DEBUG
    static let appStoreURL = URL(string: "https://apps.apple.com/app/idXXXXXXXXXX")!
    #else
    static let appStoreURL = URL(string: "https://apps.apple.com/app/idXXXXXXXXXX")!
    #endif

    static let shareButtonTitle = "共有する"
}

