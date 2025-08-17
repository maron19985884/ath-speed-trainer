import Foundation
import AudioToolbox

/// アプリ内で使用する効果音を管理する列挙型
/// ID はすべてバイブレーションを伴わない SystemSoundID を採用する
enum SESound: SystemSoundID {
    case success   = 1322  // Anticipate
    case failure   = 1053  // SIMToolkit NegativeACK
    case finish    = 1054  // SIMToolkit SMSReceived
    case decide    = 1057  // SIMToolkit CallDrop
}

final class SEManager {
    static let shared = SEManager()
    private init() {}

    private var isSeOn: Bool {
        UserDefaults.standard.object(forKey: "isSeOn") as? Bool ?? true
    }

    /// 指定された効果音を再生する
    /// - Note: `SESound` 以外の任意IDを再生しない設計で、振動は発生しない
    func play(_ sound: SESound) {
        guard isSeOn else { return }
        AudioServicesPlaySystemSound(sound.rawValue)
    }
}
