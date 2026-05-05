//
//  splashPresenter.swift
//  SportFolio
//
 
//

import UIKit

 
enum SplashSport {
    case soccer
    case basketball
    case volleyball

 
    var gradientColors: (UIColor, UIColor) {
        switch self {
        case .soccer:
            return (
                UIColor(red: 0.04, green: 0.30, blue: 0.09, alpha: 1),
                UIColor(red: 0.01, green: 0.10, blue: 0.03, alpha: 1)
            )
        case .basketball:
            return (
                UIColor(red: 0.45, green: 0.17, blue: 0.01, alpha: 1),
                UIColor(red: 0.15, green: 0.05, blue: 0.00, alpha: 1)
            )
        case .volleyball:
            return (
                UIColor(red: 0.04, green: 0.18, blue: 0.45, alpha: 1),
                UIColor(red: 0.01, green: 0.06, blue: 0.18, alpha: 1)
            )
        }
    }

 
    var accentColor: UIColor {
        switch self {
        case .soccer:     return UIColor(red: 0.20, green: 0.85, blue: 0.30, alpha: 0.6)
        case .basketball: return UIColor(red: 1.00, green: 0.50, blue: 0.10, alpha: 0.6)
        case .volleyball: return UIColor(red: 0.20, green: 0.60, blue: 1.00, alpha: 0.6)
        }
    }
}

 
protocol SplashViewProtocol: AnyObject {
    func updateTheme(for sport: SplashSport)
    func navigateToMain()
}
 
final class SplashPresenter {

    weak var view: SplashViewProtocol?

 
    private let totalDuration: Double = 9.4

    func attachView(_ view: SplashViewProtocol) {
        self.view = view
        scheduleTransitions()
    }

    private func scheduleTransitions() {
     
        view?.updateTheme(for: .soccer)

       
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.view?.updateTheme(for: .basketball)
        }

     
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.4) { [weak self] in
            self?.view?.updateTheme(for: .volleyball)
        }

     
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 0.6) { [weak self] in
            self?.view?.navigateToMain()
        }
    }
}
