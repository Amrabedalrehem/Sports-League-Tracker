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
        view.backgroundColor = .black
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
        
        titleLabel.textColor = .white
        descLabel.textColor = .white
        
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

    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        view.layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
}
