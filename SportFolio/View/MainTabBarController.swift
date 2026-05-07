import UIKit

class MainTabBarController: UITabBarController {

    private var gradientStart: UIColor { .tabBarGradientStart }
    private var gradientEnd:   UIColor { .tabBarGradientEnd   }
    private var gradientImageSize: CGSize = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard tabBar.bounds.size != gradientImageSize else { return }
        gradientImageSize = tabBar.bounds.size
        applyTabBarAppearance()
    }

      override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            gradientImageSize = .zero
            applyTabBarAppearance()
        }
    }

    private func applyTabBarAppearance() {
        let size            = tabBar.bounds.size
        let background      = makeBackgroundImage(size: size)
        let selectedColor   = UIColor.white
        let unselectedColor = UIColor.white.withAlphaComponent(0.50)

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = background
            appearance.shadowColor     = .clear

            let item = UITabBarItemAppearance()

            item.selected.iconColor = selectedColor
            item.selected.titleTextAttributes = [
                .foregroundColor: selectedColor,
                .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
            ]

            item.normal.iconColor = unselectedColor
            item.normal.titleTextAttributes = [
                .foregroundColor: unselectedColor,
                .font: UIFont.systemFont(ofSize: 10, weight: .regular)
            ]

            appearance.stackedLayoutAppearance       = item
            appearance.inlineLayoutAppearance        = item
            appearance.compactInlineLayoutAppearance = item

            tabBar.standardAppearance   = appearance
            tabBar.scrollEdgeAppearance = appearance

        } else {
            tabBar.backgroundImage         = background
            tabBar.shadowImage             = UIImage()
            tabBar.tintColor               = selectedColor
            tabBar.unselectedItemTintColor = unselectedColor
        }

        addTopSeparator()
    }

       private func makeBackgroundImage(size: CGSize) -> UIImage {
        let isDark = traitCollection.userInterfaceStyle == .dark

        let renderer = UIGraphicsImageRenderer(size: size)

        if isDark {
                  return renderer.image { ctx in
                gradientStart.setFill()
                ctx.fill(CGRect(origin: .zero, size: size))
            }
        } else {
              let layer        = CAGradientLayer()
            layer.frame      = CGRect(origin: .zero, size: size)
            layer.colors     = [gradientStart.cgColor, gradientEnd.cgColor]
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint   = CGPoint(x: 1, y: 0.5)

            return renderer.image { ctx in
                layer.render(in: ctx.cgContext)
            }
        }
    }

    private func addTopSeparator() {
        tabBar.subviews
            .filter { $0.tag == 1 }
            .forEach { $0.removeFromSuperview() }

        let separator = UIView()
        separator.tag = 1
        separator.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        separator.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(separator)
    }
}

