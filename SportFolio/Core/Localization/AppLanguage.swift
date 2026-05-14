import UIKit

enum AppLanguage: String {
    case english = "en"
    case arabic = "ar"
}

final class LanguageManager {

    static let shared = LanguageManager()

    private let key = "app_language"

    var currentLanguage: AppLanguage {

        get {

            let saved = UserDefaults.standard.string(forKey: key)

            return AppLanguage(rawValue: saved ?? "en") ?? .english
        }

        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        }
    }

    func setLanguage(_ language: AppLanguage) {

        currentLanguage = language

        UserDefaults.standard.set(
            [language.rawValue],
            forKey: "AppleLanguages"
        )

        UserDefaults.standard.synchronize()

        restartApp()
    }

    private func restartApp() {

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let rootVC = storyboard.instantiateInitialViewController()

        window.rootViewController = rootVC
        window.makeKeyAndVisible()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}