import Foundation
import AppTrackingTransparency

final class TrackingPermissionManager {
    static let shared = TrackingPermissionManager()

    private(set) var status: ATTrackingManager.AuthorizationStatus {
        didSet {
            UserDefaults.standard.set(status.rawValue, forKey: AdConfig.trackingStatusKey)
        }
    }

    var isAuthorized: Bool { status == .authorized }

    private init() {
        if let value = UserDefaults.standard.object(forKey: AdConfig.trackingStatusKey) as? Int,
           let cachedStatus = ATTrackingManager.AuthorizationStatus(rawValue: value) {
            status = cachedStatus
        } else {
            status = ATTrackingManager.trackingAuthorizationStatus
        }
    }

    func requestIfNeeded(completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        let current = ATTrackingManager.trackingAuthorizationStatus
        guard current == .notDetermined else {
            status = current
            completion(status)
            return
        }

        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.async {
                self.status = status
                #if DEBUG
                print("[TrackingPermission] status: \(status)")
                #endif
                completion(status)
            }
        }
    }

    func refreshStatus() {
        let current = ATTrackingManager.trackingAuthorizationStatus
        if status != current {
            status = current
            #if DEBUG
            print("[TrackingPermission] refreshed: \(status)")
            #endif
        }
    }
}

