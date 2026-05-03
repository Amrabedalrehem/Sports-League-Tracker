//
//  OnBoardingPresenter.swift
//  SportFolio
//
//  Created by Shahdudaa on 03/05/2026.
//

import Foundation

class OnboardingPresenter {
    
    weak var view: OnboardingView?

    func attachView(_ view: OnboardingView) {
        self.view = view
    }

    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Welcome", description: "All sports in one app", imageName: "onboarding1"),
        OnboardingPage(title: "Live Matches", description: "Watch live games", imageName: "onboarding2"),
        OnboardingPage(title: "Favorites", description: "Save your leagues", imageName: "onboarding3")
    ]

    func getPageCount() -> Int {
        return pages.count
    }

    func finish() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        view?.navigateToHome()
    }
}


