import Foundation
import AVFoundation
import AudioToolbox

enum SESound: SystemSoundID {
    case button      = 1104  // Tock（クリック）
    case decide      = 1057  // 決定/軽いビープ
    case success     = 1117  // 成功
    case failure     = 1118  // 失敗
    case countdown   = 1057  // カウント刻み
    case start       = 1113  // 開始（必要に応じ調整）
    case finish      = 1001  // 完了/終了（必要に応じ調整）
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
