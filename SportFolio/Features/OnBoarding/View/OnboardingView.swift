//
//  OnboardingView.swift
//  SportFolio
//

import UIKit

protocol OnboardingView: AnyObject {
    func navigateToHome()
}

class OnboardingPageViewController: UIPageViewController {

    var presenter = OnboardingPresenter()
    var pages: [OnboardingContentVC] = []

   
    private var isRTL: Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        dataSource = self

        if isRTL {
            view.semanticContentAttribute = .forceRightToLeft
        }
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupPages()
    }

    private func setupPages() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        pages = presenter.pages.enumerated().map { index, page in
            let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingContentVC") as! OnboardingContentVC

            vc.configure(with: page, index: index, total: presenter.pages.count)

            vc.onFinish = { [weak self] in
                self?.presenter.finish()
            }

            vc.onNext = { [weak self] in
                guard let self,
                      let current = self.viewControllers?.first as? OnboardingContentVC,
                      let idx = self.pages.firstIndex(of: current),
                      idx < self.pages.count - 1 else { return }


                let direction: UIPageViewController.NavigationDirection = self.isRTL ? .reverse : .forward
                self.setViewControllers(
                    [self.pages[idx + 1]],
                    direction: direction,
                    animated: true
                )
            }

            return vc
        }

        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: false)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController as? OnboardingContentVC,
              let idx = pages.firstIndex(of: vc) else { return nil }

        
        if isRTL {
            return idx < pages.count - 1 ? pages[idx + 1] : nil
        } else {
            return idx > 0 ? pages[idx - 1] : nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let vc = viewController as? OnboardingContentVC,
              let idx = pages.firstIndex(of: vc) else { return nil }

      
        if isRTL {
            return idx > 0 ? pages[idx - 1] : nil
        } else {
            return idx < pages.count - 1 ? pages[idx + 1] : nil
        }
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let vc = viewControllers?.first as? OnboardingContentVC,
              let index = pages.firstIndex(of: vc) else { return 0 }
        return index
    }
}

extension OnboardingPageViewController: OnboardingView {
    func navigateToHome() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        let navController = UINavigationController(rootViewController: tabBar)

        guard let window = view.window else { return }

        window.rootViewController = navController

        UIView.transition(
            with: window,
            duration: 0.4,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
