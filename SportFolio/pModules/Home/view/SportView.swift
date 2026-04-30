//
//  ViewController.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 28/04/2026.
//

import UIKit

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var sportsCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
       
        private let presenter = SportsPresenter()
        private let banners = ["banner1", "banner2", "banner3","banner4","banner5","banner6","banner8"]
        private var currentBannerIndex = 0
        private var bannerTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }

        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self

        sportsCollectionView.dataSource = self
        sportsCollectionView.delegate = self

        presenter.attachView(self)
        startBannerTimer()
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
            if collectionView == sportsCollectionView {
                let selectedSport = presenter.didSelectSport(at: indexPath.row)
                print("Selected sport: \(selectedSport.name)")
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
    }
