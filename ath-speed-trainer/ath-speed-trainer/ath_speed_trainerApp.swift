//
//  ath_speed_trainerApp.swift
//  ath-speed-trainer
//
//  Created by 小林　景大 on 2025/07/30.
//

import SwiftUI
import GoogleMobileAds

@main
struct ath_speed_trainerApp: App {

    init() {
        if AdConfig.isAdsEnabled {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            #if DEBUG
            GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [GADSimulatorID]
            #endif
            InterstitialAdCoordinator.shared.preload()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
