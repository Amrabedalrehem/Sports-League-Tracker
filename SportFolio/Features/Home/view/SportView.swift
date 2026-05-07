//
//  ViewController.swift
//  SportFolio
//

import UIKit

protocol SportViewProtocol: AnyObject {
    func showNoInternet()
    func updateThemeButton(isDark: Bool)
}

class ViewController: UIViewController,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UICollectionViewDelegateFlowLayout,
                      SportViewProtocol {
        @IBOutlet weak var navBar: UINavigationItem!
    
   
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!

    
    private let presenter = SportsPresenter()

    private let banners = [
        "banner1", "banner2", "banner3",
        "banner4", "banner5", "banner6", "banner8"
    ]

    private var currentBannerIndex = 0
    private var bannerTimer: Timer?


    private var themeButton: UIBarButtonItem!
    private var floatingThemeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationButton()
        setupBannerLayout()
        setupFloatingThemeButton()
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self

        presenter.attachView(self)

        startBannerTimer()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          applyNavBarAppearance()
    }

     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            applyNavBarAppearance()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }

       private func applyNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor   = .tabBarGradientStart
        appearance.shadowColor       = .clear

        let titleAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .bold)
        ]
        appearance.titleTextAttributes = titleAttrs

        navigationController?.navigationBar.standardAppearance    = appearance
        navigationController?.navigationBar.scrollEdgeAppearance  = appearance
        navigationController?.navigationBar.compactAppearance     = appearance
        navigationController?.navigationBar.tintColor             = .white
    }

    func setupNavigationButton() {
        let isDark = ThemeManager.shared.currentTheme == .dark
        navigationItem.title = "SportFolio"

        let imageName = isDark ? "lightbulb.fill" : "lightbulb"
        let config    = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image     = UIImage(systemName: imageName, withConfiguration: config)
        themeButton   = UIBarButtonItem(image: image, style: .plain,
                                       target: self, action: #selector(themeTapped))
        navigationItem.rightBarButtonItem = themeButton
    }

      private func setupFloatingThemeButton() {
        let isDark   = ThemeManager.shared.currentTheme == .dark
        let iconName = isDark ? "moon.fill" : "sun.max.fill"
        let config   = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)

        floatingThemeBtn = UIButton(type: .system)
        floatingThemeBtn.setImage(UIImage(systemName: iconName, withConfiguration: config), for: .normal)
        floatingThemeBtn.tintColor            = .white
        floatingThemeBtn.backgroundColor      = .tabBarGradientStart
        floatingThemeBtn.layer.cornerRadius   = 22
        floatingThemeBtn.layer.shadowColor    = UIColor.black.cgColor
        floatingThemeBtn.layer.shadowOpacity  = 0.25
        floatingThemeBtn.layer.shadowOffset   = CGSize(width: 0, height: 4)
        floatingThemeBtn.layer.shadowRadius   = 8
        floatingThemeBtn.translatesAutoresizingMaskIntoConstraints = false
        floatingThemeBtn.addTarget(self, action: #selector(themeTapped), for: .touchUpInside)

        view.addSubview(floatingThemeBtn)
        NSLayoutConstraint.activate([
            floatingThemeBtn.widthAnchor.constraint(equalToConstant: 44),
            floatingThemeBtn.heightAnchor.constraint(equalToConstant: 44),
            floatingThemeBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            floatingThemeBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        ])
    }

      private func setupBannerLayout() {
        guard let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection  = .horizontal
        layout.minimumLineSpacing = 0
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.showsHorizontalScrollIndicator = false
    }

    @objc func themeTapped() {
        let isDark = presenter.toggleTheme()
     let navIconName = isDark ? "lightbulb.fill" : "lightbulb"
        let config      = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        themeButton.image = UIImage(systemName: navIconName, withConfiguration: config)

          let floatIconName = isDark ? "moon.fill" : "sun.max.fill"
        let floatConfig   = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        floatingThemeBtn.setImage(UIImage(systemName: floatIconName, withConfiguration: floatConfig), for: .normal)
     UIView.animate(withDuration: 0.12, animations: {
            self.floatingThemeBtn.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }) { _ in
            UIView.animate(withDuration: 0.15,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 6) {
                self.floatingThemeBtn.transform = .identity
            }
        }

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    func addGlow() { }
    func removeGlow() { }

    func setupUI() {
        view.backgroundColor = .appBackground
    }

   
    func reloadData() {
        sportsCollectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        return collectionView == bannerCollectionView
        ? banners.count
        : presenter.getSportsCount()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == bannerCollectionView {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "bannerCell",
                for: indexPath
            ) as! BannerCell

            cell.bannerImageView.image = UIImage(named: banners[indexPath.row])
            return cell

        } else {

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "sportCell",
                for: indexPath
            ) as! SportCell

            let sport = presenter.getSport(at: indexPath.row)
            cell.sportName.text = sport.name
            cell.sportImage.image = UIImage(named: sport.image)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        guard presenter.isOnline() else {
            showNoInternet()
            return
        }

        let leaguesVC = storyboard?.instantiateViewController(
            withIdentifier: "LeaguesViewTable"
        ) as! LeaguesViewTable

        leaguesVC.presenter = LeaguesPresenter(
            sportType: presenter.getSport(at: indexPath.row).sportType
        )

        navigationController?.pushViewController(leaguesVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == bannerCollectionView {
            return CGSize(width: collectionView.frame.width,
                          height: collectionView.frame.height)
        } else {

            let spacing: CGFloat = 10
            let itemsPerRow: CGFloat = 2
            let total = (itemsPerRow + 1) * spacing

            let width = (collectionView.bounds.width - total) / itemsPerRow

            return CGSize(width: width, height: width)
        }
    }

   
    func startBannerTimer() {

        bannerTimer = Timer.scheduledTimer(
            timeInterval: 2.5,
            target: self,
            selector: #selector(nextBanner),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func nextBanner() {
        guard !banners.isEmpty else { return }

        currentBannerIndex = (currentBannerIndex + 1) % banners.count

        bannerCollectionView.scrollToItem(
            at: IndexPath(item: currentBannerIndex, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
    }

    deinit {
        bannerTimer?.invalidate()
    }

    
    func showNoInternet() {
        NetworkMonitor.shared.showNoInternet(on: self)
    }

    func updateThemeButton(isDark: Bool) {
        let navIconName = isDark ? "lightbulb.fill" : "lightbulb"
        let config      = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        themeButton.image = UIImage(systemName: navIconName, withConfiguration: config)

        let floatIconName = isDark ? "moon.fill" : "sun.max.fill"
        let floatConfig   = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        floatingThemeBtn?.setImage(UIImage(systemName: floatIconName, withConfiguration: floatConfig), for: .normal)
    }
}
