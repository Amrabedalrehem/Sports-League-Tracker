//
//  AppTheme.swift
//  SportFolio
//
//  Created by Shahudaa on 06/05/2026.
//


import UIKit

enum AppTheme: Int {
    case light
    case dark
}

final class ThemeManager {
    
    static let shared = ThemeManager()
    private let key = "app_theme"
    
    var currentTheme: AppTheme {
        get {
            let value = UserDefaults.standard.integer(forKey: key)
            return AppTheme(rawValue: value) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
            applyTheme(newValue)
        }
    }
    
    func applyTheme(_ theme: AppTheme) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    
}
