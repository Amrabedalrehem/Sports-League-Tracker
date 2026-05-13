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


    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupBannerLayout()
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self
        presenter.attachView(self)
        startBannerTimer()
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          applyNavBarAppearance(navigationController: navigationController)
        setupNavigationButton()
        
    }

     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            applyNavBarAppearance(navigationController: navigationController)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
    }

     
    func setupNavigationButton() {
        let isDark = ThemeManager.shared.currentTheme == .dark
        navigationItem.title = L10n.navSportfolio

        let imageName = isDark ? "lightbulb.fill" :"lightbulb"
        let config    = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image     = UIImage(systemName: imageName, withConfiguration: config)
        themeButton   = UIBarButtonItem(image: image, style: .plain,
                                       target: self, action: #selector(themeTapped))
        navigationItem.rightBarButtonItem = themeButton
        navigationController?.navigationBar.topItem?.rightBarButtonItem = themeButton
    }


      private func setupBannerLayout() {
        guard let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.scrollDirection  = .horizontal
        layout.minimumLineSpacing = 0
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.showsHorizontalScrollIndicator = false
    }

    @objc func themeTapped() {
            presenter.toggleTheme()
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
 
        guard collectionView == sportsCollectionView else { return }

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

            let itemsPerRow: CGFloat = 2

            let width = (collectionView.bounds.width / itemsPerRow)-16
            return CGSize(width: width , height: width + 100)
        }
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == bannerCollectionView {
            return 0
        }

        return 24
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
        let navIconName = isDark ?   "lightbulb" :"lightbulb.fill"
        let config      = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        themeButton.image = UIImage(systemName: navIconName, withConfiguration: config)

    }
}
