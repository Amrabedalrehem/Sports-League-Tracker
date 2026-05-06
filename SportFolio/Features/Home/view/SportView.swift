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
    private var themeButtonView: UIButton!

   
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationButton()

        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self

        presenter.attachView(self)

        startBannerTimer()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }

    func setupNavigationButton() {

        let isDark = ThemeManager.shared.currentTheme == .dark

        themeButtonView = UIButton(type: .system)
        themeButtonView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        let imageName = isDark ? "lightbulb.fill" : "lightbulb"
        themeButtonView.setImage(UIImage(systemName: imageName), for: .normal)
        themeButtonView.tintColor = .label

        themeButtonView.addTarget(
            self,
            action: #selector(themeTapped),
            for: .touchUpInside
        )

        themeButton = UIBarButtonItem(customView: themeButtonView)
      
        navBar.rightBarButtonItem = themeButton

        if isDark {
            addGlow()
        }
    }

    @objc func themeTapped() {

        UIView.animate(withDuration: 0.15) {
            self.themeButtonView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { _ in
            UIView.animate(withDuration: 0.15) {
                self.themeButtonView.transform = .identity
            }
        }

        let isDark = presenter.toggleTheme()

        let imageName = isDark ? "lightbulb.fill" : "lightbulb"
        themeButtonView.setImage(UIImage(systemName: imageName), for: .normal)

        if isDark {
            addGlow()
        } else {
            removeGlow()
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func addGlow() {
        themeButtonView.layer.shadowColor = UIColor.systemYellow.cgColor
        themeButtonView.layer.shadowRadius = 12
        themeButtonView.layer.shadowOpacity = 0.9
        themeButtonView.layer.shadowOffset = .zero
    }

    func removeGlow() {
        themeButtonView.layer.shadowOpacity = 0
    }

    func setupUI() {
        view.backgroundColor = .systemBackground
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
        let imageName = isDark ? "lightbulb.fill" : "lightbulb"
        themeButtonView.setImage(UIImage(systemName: imageName), for: .normal)

        if isDark {
            addGlow()
        } else {
            removeGlow()
        }
    }
}
