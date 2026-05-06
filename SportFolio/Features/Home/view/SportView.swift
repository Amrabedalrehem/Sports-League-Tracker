//
//  ViewController.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 28/04/2026.
//

import UIKit

import UIKit
protocol  SportViewProtocol: AnyObject {
    func showNoInternet()
}
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , SportViewProtocol {
    
    
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    private let presenter = SportsPresenter()
    private let banners = ["banner1", "banner2", "banner3","banner4","banner5","banner6","banner8"]
    private var currentBannerIndex = 0
    private var bannerTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        if let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.titleView = nil
        navigationItem.title = "Home"
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self
        presenter.attachView(self)
        startBannerTimer()
        polishBackground()
        polishNavigationBar()
        polishBanner()
        print(navigationController) // should NOT be nil
    }
    func reloadData() {
        sportsCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bannerCollectionView {
            return banners.count
        } else {
            return presenter.getSportsCount()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == bannerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCell
            cell.bannerImageView.image = UIImage(named: banners[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportCell", for: indexPath) as! SportCell
            let sport = presenter.getSport(at: indexPath.row)
            cell.sportName.text = sport.name
            cell.sportImage.image = UIImage(named: sport.image)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard presenter.isOnline() else {
            showNoInternet()
            return
        }
        if collectionView == sportsCollectionView {
            let selectedSport = presenter.didSelectSport(at: indexPath.row)
            print("Selected sport: \(selectedSport.name)")
            let leaguesVC = self.storyboard?.instantiateViewController(withIdentifier: "LeaguesViewTable") as! LeaguesViewTable
            leaguesVC.presenter = LeaguesPresenter(sportType: presenter.getSport(at: indexPath.row).sportType)
            
            self.navigationController?.pushViewController(leaguesVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            let spacing: CGFloat = 10
            let itemsPerRow: CGFloat = 2
            let totalSpacing = (itemsPerRow + 1) * spacing
            let availableWidth = collectionView.bounds.width - totalSpacing
            let itemWidth = availableWidth / itemsPerRow
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    private func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextBanner), userInfo: nil, repeats: true)
    }
    
    @objc private func moveToNextBanner() {
        guard !banners.isEmpty else { return }
        
        currentBannerIndex += 1
        if currentBannerIndex >= banners.count {
            currentBannerIndex = 0
        }
        
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    deinit {
        bannerTimer?.invalidate()
    }
    
    
    private func polishBackground() {
        view.backgroundColor = .appBackground
        sportsCollectionView.backgroundColor = .clear
    }
    
    private func polishNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.06)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.mainText,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance   = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance    = appearance
        navigationController?.navigationBar.tintColor = .primaryBlue
    }
    
    private func polishBanner() {
        
        bannerCollectionView.layer.cornerRadius = 20
        bannerCollectionView.layer.masksToBounds = true
        bannerCollectionView.showsHorizontalScrollIndicator = false
        
        
        bannerCollectionView.layer.shadowColor = UIColor.shadowColorApp.cgColor
        bannerCollectionView.layer.shadowOpacity = 0.14
        bannerCollectionView.layer.shadowOffset = CGSize(width: 0, height: 5)
        bannerCollectionView.layer.shadowRadius = 12
        bannerCollectionView.layer.masksToBounds = false
        
        
        bannerCollectionView.clipsToBounds = true
    }
    
    
    func showNoInternet() {
        NetworkMonitor.shared.showNoInternet(on: self)
    }
}
