import UIKit

class MainTabBarController: UITabBarController {

   
    private let gradientStart = UIColor(red: 0.043, green: 0.239, blue: 0.812, alpha: 1.0)
    private let gradientEnd   = UIColor(red: 0.196, green: 0.620, blue: 0.965, alpha: 1.0)

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

    

    private func applyTabBarAppearance() {
        let size      = tabBar.bounds.size
        let gradient  = makeGradientImage(size: size)

       
        let selectedColor   = UIColor.white
        let unselectedColor = UIColor.white.withAlphaComponent(0.50)

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundImage = gradient
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

            appearance.stackedLayoutAppearance        = item
            appearance.inlineLayoutAppearance         = item
            appearance.compactInlineLayoutAppearance  = item

            tabBar.standardAppearance   = appearance
            tabBar.scrollEdgeAppearance = appearance

        } else {
            tabBar.backgroundImage      = gradient
            tabBar.shadowImage          = UIImage()
            tabBar.tintColor            = selectedColor
            tabBar.unselectedItemTintColor = unselectedColor
        }

       
        addTopSeparator()
    }

    
    private func makeGradientImage(size: CGSize) -> UIImage {
        let layer        = CAGradientLayer()
        layer.frame      = CGRect(origin: .zero, size: size)
        layer.colors     = [gradientStart.cgColor, gradientEnd.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint   = CGPoint(x: 1, y: 0.5)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            layer.render(in: ctx.cgContext)
        }
    }

  
    private func addTopSeparator() {
     
        tabBar.subviews
            .filter { $0.tag == 9_001 }
            .forEach { $0.removeFromSuperview() }

        let separator              = UIView()
        separator.tag              = 9_001
        separator.backgroundColor  = UIColor.white.withAlphaComponent(0.25)
        separator.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: tabBar.topAnchor),
            separator.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
