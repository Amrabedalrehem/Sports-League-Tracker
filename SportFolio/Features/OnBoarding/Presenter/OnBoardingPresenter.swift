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
        OnboardingPage(title: "Discover Your Favorite Sports", description: "Explore football, basketball, tennis, and cricket in one place. Stay updated with the latest leagues, matches, and teams.", imageName: "onboarding1"),
        OnboardingPage(title: "All Leagues & Teams in Your Pocket", description: "Get detailed information about leagues and teams, including stats, results, and upcoming matches—everything you need, instantly.", imageName: "onboarding2"),
        OnboardingPage(title: "Follow What You Love", description: "Save your favorite leagues to get quick access and personalized updates tailored just for you.", imageName: "onboarding3")
    ]

    func getPageCount() -> Int {
        return pages.count
    }

    func finish() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        view?.navigateToHome()
    }
}


