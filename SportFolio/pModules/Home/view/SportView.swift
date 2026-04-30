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
         private let presenter = SportsPresenter()

        override func viewDidLoad() {
            super.viewDidLoad()

            sportsCollectionView.dataSource = self
            sportsCollectionView.delegate = self

            presenter.attachView(self)
        }

        func reloadData() {
            sportsCollectionView.reloadData()
        }

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            1
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            presenter.getSportsCount()
        }

 

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedSport = presenter.didSelectSport(at: indexPath.row)
            print("Selected sport: \(selectedSport.name)")
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let spacing: CGFloat = 10
            let itemsPerRow: CGFloat = 2
            let totalSpacing = (itemsPerRow + 1) * spacing
            let availableWidth = collectionView.bounds.width - totalSpacing
            let itemWidth = availableWidth / itemsPerRow
            return CGSize(width: itemWidth, height: itemWidth)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sportCell", for: indexPath) as! SportCell

        let sport = presenter.getSport(at: indexPath.row)
        cell.sportName.text = sport.name
        cell.sportImage.image = UIImage(named: sport.image)

        return cell
    }
    }
