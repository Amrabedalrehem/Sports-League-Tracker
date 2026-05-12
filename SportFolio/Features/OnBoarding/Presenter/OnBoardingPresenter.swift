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

        OnboardingPage(
            title: L10n.onboardingPage1Title,
            description: L10n.onboardingPage1Description,
            imageName: "onboarding1"
        ),

        OnboardingPage(
            title: L10n.onboardingPage2Title,
            description: L10n.onboardingPage2Description,
            imageName: "onboarding2"
        ),

        OnboardingPage(
            title: L10n.onboardingPage3Title,
            description: L10n.onboardingPage3Description,
            imageName: "onboarding3"
        )
    ]

    func getPageCount() -> Int {
        return pages.count
    }

    func finish() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        view?.navigateToHome()
    }
}


