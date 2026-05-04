//
//  OnboardingContentVC.swift
//  SportFolio
//
//  Created by ITI_JETS on 04/05/2026.
//

import UIKit

class OnboardingContentVC: UIViewController {

    var onNext: (() -> Void)?
    var onFinish: (() -> Void)?

    private var isLastPage = false

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addGradient()
    }

    func configure(with page: OnboardingPage, index: Int, total: Int) {
       
        self.loadViewIfNeeded()
        
        imageView.image = UIImage(named: page.imageName)
        titleLabel.text = page.title
        descLabel.text = page.description
        pageControl.numberOfPages = total
        pageControl.currentPage = index
        isLastPage = (index == total - 1)
        actionButton.setTitle(isLastPage ? "Get Started" : "Next", for: .normal)
    }

    @IBAction private func actionTapped(_ sender: UIButton) {
        if isLastPage {
            onFinish?()
        } else {
            onNext?()
        }
    }
    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = imageView.bounds

        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]

        gradient.locations = [0.0, 1.0]
        imageView.layer.addSublayer(gradient)
    }
}


