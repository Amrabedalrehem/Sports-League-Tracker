//
//  LatestEventsContainerCell.swift
//  SportFolio
//
//  Created by ITI_JETS on 02/05/2026.
//

import UIKit

class LatestEventsContainerCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

    var events: [EventModel] = []

    override func awakeFromNib() {
        super.awakeFromNib()

        setupCollectionView()
    }

    private func setupCollectionView() {

        collectionView.dataSource = self
        collectionView.delegate = self

        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12

        collectionView.collectionViewLayout = layout

    
        collectionView.register(
            UINib(nibName: "LatestEventCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "LatestEventCollectionViewCell"
        )

        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
    }
}
extension LatestEventsContainerCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "LatestEventCollectionViewCell",
            for: indexPath
        ) as! LatestEventCollectionViewCell

        let event = events[indexPath.row]

        cell.homeTeamNameLabel.text = event.eventHomeTeam
        cell.awayTeamNameLabel.text = event.eventAwayTeam
        cell.scoreLabel.text = event.eventFinalResult
        cell.dateLabel.text = event.eventDate

        cell.homeTeamImageView.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(named: "placeholder"))

        cell.awayTeamImageView.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(named: "placeholder"))

        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: 180)
    }
}
