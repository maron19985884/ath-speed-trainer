import Foundation
import AVFoundation
import AudioToolbox

enum SESound: SystemSoundID {
    case button    = 1052  // SIMToolkit General Beep (定番避け)
    case decide    = 1024  // Descent (エッジある選択音)
    case success   = 1322  // Fanfare (通知系だが少し控えめ)
    case failure   = 1053  // SIMToolkit NegativeACK (やや硬質なエラー音)
    case countdown = 1033  // Telegraph (カウントや警告用途でも目立ちすぎず)
    case start     = 1021  // Bloom (柔らかい開始音)
    case finish    = 1054  // Noir (終了音として静かめに)
}


final class SEManager {
    static let shared = SEManager()
    private init() {}

    private var isSeOn: Bool {
        UserDefaults.standard.object(forKey: "isSeOn") as? Bool ?? true
    }

    func play(_ sound: SESound) {
        guard isSeOn else { return }
        AudioServicesPlaySystemSound(sound.rawValue)
    }
}
