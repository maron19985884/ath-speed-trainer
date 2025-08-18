import Foundation
import GoogleMobileAds

struct AdRequestFactory {
    static func make() -> GADRequest {
        let request = GADRequest()
        if TrackingPermissionManager.shared.isAuthorized {
            #if DEBUG
            print("[AdRequest] personalized")
            #endif
            return request
        } else {
            let extras = GADExtras()
            extras.additionalParameters = ["npa": "1"]
            request.register(extras)
            #if DEBUG
            print("[AdRequest] non-personalized")
            #endif
            return request
        }
    }
}

