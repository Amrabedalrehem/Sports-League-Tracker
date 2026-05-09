//
//  LatestEventsContainerCell.swift
//  SportFolio
//

import UIKit

class LatestEventsContainerCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!

   
    private let emptyStateView = UIView()
    private let emptyIcon      = UIImageView()
    private let emptyLabel     = UILabel()

    var events: [EventModel] = [] {
        didSet { updateEmptyState() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupEmptyState()
    }

   
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.backgroundColor = .clear

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection    = .vertical
        layout.minimumLineSpacing = 12
        collectionView.contentInset      = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        collectionView.collectionViewLayout = layout

        collectionView.register(
            UINib(nibName: "LatestEventCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "LatestEventCollectionViewCell"
        )
        collectionView.isScrollEnabled          = true
        collectionView.showsVerticalScrollIndicator = true
    }

    
    private func setupEmptyState() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.isHidden = true
        contentView.addSubview(emptyStateView)

        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        emptyIcon.image = UIImage(systemName: "calendar.badge.exclamationmark", withConfiguration: config)
        emptyIcon.tintColor = .primaryBlueLight
        emptyIcon.contentMode = .scaleAspectFit
        emptyIcon.translatesAutoresizingMaskIntoConstraints = false

        emptyLabel.text = L10n.emptyLatestMatches
        emptyLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        emptyLabel.textColor = UIColor.tertiaryLabel
        emptyLabel.textAlignment = .center
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false

        emptyStateView.addSubview(emptyIcon)
        emptyStateView.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            emptyIcon.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyIcon.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyIcon.widthAnchor.constraint(equalToConstant: 54),
            emptyIcon.heightAnchor.constraint(equalToConstant: 54),

            emptyLabel.topAnchor.constraint(equalTo: emptyIcon.bottomAnchor, constant: 12),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
        ])
    }

    private func updateEmptyState() {
        let isEmpty = events.isEmpty
        emptyStateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
        collectionView.reloadData()
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
        cell.configure(
            homeName: event.eventHomeTeam,
            awayName: event.eventAwayTeam,
            score:    event.eventFinalResult,
            date:     event.eventDate
        )
        cell.homeTeamImageView.sd_setImage(
            with: URL(string: event.homeTeamLogo ?? ""),
            placeholderImage: UIImage(named: "clubPlaceholder"))
        cell.awayTeamImageView.sd_setImage(
            with: URL(string: event.awayTeamLogo ?? ""),
            placeholderImage: UIImage(named: "clubPlaceholder"))

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeWidth = collectionView.frame.width
            - collectionView.contentInset.left
            - collectionView.contentInset.right
        return CGSize(width: safeWidth, height: 150)
    }
}
