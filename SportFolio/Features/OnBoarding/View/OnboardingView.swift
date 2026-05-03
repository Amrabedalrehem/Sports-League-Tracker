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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        dataSource = self
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupPages()
    }

    private func setupPages() {
        pages = presenter.pages.enumerated().map { index, page in
            let vc = OnboardingContentVC()
            vc.configure(with: page, index: index, total: presenter.pages.count)
            vc.onFinish = { [weak self] in
                self?.presenter.finish()
            }
            vc.onNext = { [weak self] in
                guard let self, let current = self.viewControllers?.first as? OnboardingContentVC,
                      let idx = self.pages.firstIndex(of: current), idx < self.pages.count - 1 else { return }
                self.setViewControllers([self.pages[idx + 1]], direction: .forward, animated: true)
            }
            return vc
        }

        guard let first = pages.first else { return }
        setViewControllers([first], direction: .forward, animated: false)
    }
}


extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingContentVC,
              let idx = pages.firstIndex(of: vc), idx > 0 else { return nil }
        return pages[idx - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingContentVC,
              let idx = pages.firstIndex(of: vc), idx < pages.count - 1 else { return nil }
        return pages[idx + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int { 0 }
}

extension OnboardingPageViewController: OnboardingView {

    func navigateToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        guard let window = view.window else { return }
        window.rootViewController = tabBar
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: nil)
    }
}


class OnboardingContentVC: UIViewController {

    
    var onNext: (() -> Void)?
    var onFinish: (() -> Void)?

    private var isLastPage = false

    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        l.textAlignment = .center
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let descLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let actionButton: UIButton = {
        let b = UIButton(type: .system)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        b.layer.cornerRadius = 14
        b.backgroundColor = .systemBlue
        b.setTitleColor(.white, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .systemBlue
        pc.pageIndicatorTintColor = .systemGray4
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descLabel)
        view.addSubview(pageControl)
        view.addSubview(actionButton)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            pageControl.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            actionButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    }


    func configure(with page: OnboardingPage, index: Int, total: Int) {
        imageView.image = UIImage(named: page.imageName)
        titleLabel.text = page.title
        descLabel.text = page.description
        pageControl.numberOfPages = total
        pageControl.currentPage = index
        isLastPage = (index == total - 1)
        actionButton.setTitle(isLastPage ? "Get Started" : "Next", for: .normal)
    }

    
    @objc private func actionTapped() {
        if isLastPage {
            onFinish?()
        } else {
            onNext?()
        }
    }
}
