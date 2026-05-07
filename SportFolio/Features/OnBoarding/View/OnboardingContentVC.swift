//
//  OnboardingContentVC.swift
//  SportFolio
//

import UIKit

class OnboardingContentVC: UIViewController {

    var onNext: (() -> Void)?
    var onFinish: (() -> Void)?
    private var isLastPage = false
    private let gradientLayer = CAGradientLayer()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupGradient()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    func configure(with page: OnboardingPage, index: Int, total: Int) {
        self.loadViewIfNeeded()
        imageView.image = UIImage(named: page.imageName)
        titleLabel.text = page.title
        descLabel.text = page.description
        pageControl.numberOfPages = total
        pageControl.currentPage = index
        isLastPage = (index == total - 1)
        actionButton.setTitle(isLastPage ? "Get Started" : "Next",for: .normal)
    }

    @IBAction private func actionTapped(_ sender: UIButton) {
        if isLastPage {
            onFinish?()
        } else {
            onNext?()
        }
    }

    private func setupGradient() {

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
