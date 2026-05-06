//
//  LeaguesDetailsCollectionViewController.swift
//  SportFolio
// created by shahudaaaa

import UIKit
import SDWebImage

private let teamCellId     = "TeamCollectionViewCell"
private let upComingCellId = "UpcomingEventCollectionViewCell"
private let latestCellId   = "LatestEventCollectionViewCell"
private let emptyCellId    = "EmptyStateCell"

protocol LeaguesDetailsView: AnyObject {
    func showLoading()
    func hideLoading()
    func showData()
    func showEmptyState()
    func showError(message: String)
    func updateFavoriteButton(isFavorite: Bool)
    func showNoInternet()
}

class LeaguesDetailsCollectionViewController: UICollectionViewController {

    var leaguesDetailsPresenter: LeaguesDetailsPresenterProtocol!
    private var favoriteButton: UIBarButtonItem?
    private var currentItemSegment: Int = 0
    private var shimmerOverlay: ShimmerOverlayView?
    private var animatedCells: Set<IndexPath> = []

  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavigationBar()
        setupCollectionView()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        leaguesDetailsPresenter.getItems()
        leaguesDetailsPresenter.getEvents()
    }

   
    private func setupBackground() {
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.98, alpha: 1)
    }

    
    private func setupNavigationBar() {
    
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        let isFavorite = leaguesDetailsPresenter.isFavorite()
        updateFavoriteButtonIcon(button, isFavorite: isFavorite)

        favoriteButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = favoriteButton
        navigationItem.title = leaguesDetailsPresenter.getLeagueName()
    }

    @objc private func favoriteButtonTapped() {
        guard let button = favoriteButton?.customView as? UIButton else { return }
        UIView.animate(withDuration: 0.2) {
            button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) { button.transform = .identity }
        }
        let isFavorite = leaguesDetailsPresenter.toggleFavorite()
        updateFavoriteButtonIcon(button, isFavorite: isFavorite)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func updateFavoriteButtonIcon(_ button: UIButton, isFavorite: Bool) {
        let config    = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let imageName = isFavorite ? "heart.fill" : "heart"
        button.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        button.tintColor = isFavorite ? .systemRed : .systemGray
    }

    
    private func setupCollectionView() {
        collectionView.register(
            UINib(nibName: "TeamCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: teamCellId
        )
        collectionView.register(
            UINib(nibName: "UpcomingEventCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: upComingCellId
        )
        collectionView.register(
            UINib(nibName: "LatestEventCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: latestCellId
        )
        collectionView.register(
            UINib(nibName: "LatestEventsContainerCell", bundle: nil),
            forCellWithReuseIdentifier: "LatestEventsContainerCell"
        )
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: emptyCellId)

        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseID
        )
    }

  
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }

            switch sectionIndex {

            case 0:
                let upcomingCount = self.leaguesDetailsPresenter?.getNumberOfUpcomingEvents() ?? 0

                if upcomingCount == 0 {
                   
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)),
                        subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
                    section.boundarySupplementaryItems = [self.createHeader(height: 52)]
                    return section
                }

                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(0.88), heightDimension: .absolute(200)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 16, trailing: 8)
                section.boundarySupplementaryItems = [self.createHeader(height: 52)]
                return section

            case 1:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(255)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0)
                section.boundarySupplementaryItems = [self.createHeader(height: 52)]
                return section

            case 2:
                let segCount = self.currentItemSegment == 0
                    ? (self.leaguesDetailsPresenter?.getNumberOfTeams() ?? 0)
                    : (self.leaguesDetailsPresenter?.getNumberOfPlayers() ?? 0)

                if segCount == 0 {
                  
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)),
                        subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 24, trailing: 0)
                    section.boundarySupplementaryItems = [self.createHeader(height: 88)]
                    return section
                }

                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(130)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(130)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 24, trailing: 8)
                section.boundarySupplementaryItems = [self.createHeader(height: 88)]
                return section

            default:
                return nil
            }
        }
    }

    private func createHeader(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(height)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
   
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseID,
            for: indexPath
        ) as! SectionHeaderView

        header.delegate = self

        switch indexPath.section {
        case 0:
            header.configure(title: "Upcoming Matches", systemIcon: "calendar.badge.clock")
        case 1:
            header.configure(title: "Latest Matches", systemIcon: "flag.checkered")
        case 2:
            let title = currentItemSegment == 0 ? "Teams" : "Players"
            header.configure(
                title: title,
                systemIcon: currentItemSegment == 0 ? "person.3.fill" : "figure.run",
                showSegmentControl: true,
                selectedSegment: currentItemSegment
            )
        default:
            header.configure(title: "", systemIcon: "")
        }
        return header
    }

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 3 }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            let count = leaguesDetailsPresenter.getNumberOfUpcomingEvents()
            return count == 0 ? 1 : count

        case 1:
            return 1

        case 2:
            let count = currentItemSegment == 0
                ? leaguesDetailsPresenter.getNumberOfTeams()
                : leaguesDetailsPresenter.getNumberOfPlayers()
            return count == 0 ? 1 : count

        default:
            return 0
        }
    }

    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {

        case 0:
            
            if leaguesDetailsPresenter.getNumberOfUpcomingEvents() == 0 {
                return makeEmptyCell(
                    collectionView, indexPath: indexPath,
                    icon: "calendar.badge.exclamationmark",
                    message: "No upcoming matches"
                )
            }
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: upComingCellId, for: indexPath
            ) as! UpcomingEventCollectionViewCell
            let event = leaguesDetailsPresenter.getUpcomingEvent(at: indexPath.row)
            let placeholder = UIImage(named: "clubPlaceholder")
            
            cell.homeTeamImageView.sd_setImage(
                with: URL(string: event.homeTeamLogo ?? ""),
                placeholderImage: placeholder
            )

            cell.awayTeamImageView.sd_setImage(
                with: URL(string: event.awayTeamLogo ?? ""),
                placeholderImage: placeholder
            )
            cell.configure(
                homeName: event.eventHomeTeam,
                awayName: event.eventAwayTeam,
                date: event.eventDate,
                time: event.eventTime
            )
            return cell

        case 1:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "LatestEventsContainerCell", for: indexPath
            ) as! LatestEventsContainerCell
            cell.events = leaguesDetailsPresenter.getLatestEvents()
            cell.collectionView.reloadData()
            return cell

        case 2:
            let count = currentItemSegment == 0
                ? leaguesDetailsPresenter.getNumberOfTeams()
                : leaguesDetailsPresenter.getNumberOfPlayers()

            if count == 0 {
                let iconName = currentItemSegment == 0 ? "person.3" : "figure.run"
                let message  = currentItemSegment == 0 ? "No teams available" : "No players available"
                return makeEmptyCell(collectionView, indexPath: indexPath, icon: iconName, message: message)
            }

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: teamCellId, for: indexPath
            ) as! TeamCollectionViewCell

            let item = currentItemSegment == 0
                ? leaguesDetailsPresenter.getTeamItem(at: indexPath.row)
                : leaguesDetailsPresenter.getPlayerItem(at: indexPath.row)

            let teamPlaceholder   = UIImage(named: "clubPlaceholder")
            let playerPlaceholder = UIImage(named: "playerPlaceholder")
            switch item {
            case .team(let team):
                cell.teamLabel.text = team.teamName ?? "–"
                cell.teamImageView.sd_setImage(
                    with: URL(string: team.teamLogo ?? ""),
                    placeholderImage: teamPlaceholder)
            case .player(let player):
                cell.teamLabel.text = player.playerName ?? "–"
                if leaguesDetailsPresenter.getSportType() == .tennis
                {
                   
                    cell.teamImageView.sd_setImage(
                        with: URL(string: player.playerLogo ?? ""),
                        placeholderImage: playerPlaceholder)
                }else
                {
                
                    cell.teamImageView.sd_setImage(
                        with: URL(string: player.playerImage ?? ""),
                        placeholderImage: playerPlaceholder)
                }
            }
            return cell

        default:
            return UICollectionViewCell()
        }
    }

   
    override func collectionView(_ collectionView: UICollectionView,
                                 willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
        guard indexPath.section == 0,
              !animatedCells.contains(indexPath),
              leaguesDetailsPresenter.getNumberOfUpcomingEvents() > 0 else { return }

        animatedCells.insert(indexPath)
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 60, y: 0).scaledBy(x: 0.92, y: 0.92)

        UIView.animate(
            withDuration: 0.45,
            delay: Double(indexPath.row) * 0.06,
            usingSpringWithDamping: 0.78,
            initialSpringVelocity: 0.4,
            options: .curveEaseOut
        ) {
            cell.alpha = 1
            cell.transform = .identity
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 2 else { return }

         if !NetworkMonitor.shared.isConnected {
            showNoInternet()
            return
        }

        let count = currentItemSegment == 0
            ? leaguesDetailsPresenter.getNumberOfTeams()
            : leaguesDetailsPresenter.getNumberOfPlayers()
        guard count > 0 else { return }

        let item = currentItemSegment == 0
            ? leaguesDetailsPresenter.getTeamItem(at: indexPath.row)
            : leaguesDetailsPresenter.getPlayerItem(at: indexPath.row)

        if case .team(let team) = item, let teamId = team.teamKey {
            let vc = storyboard?.instantiateViewController(withIdentifier: "TeamTableViewController") as! TeamTableViewController
            let presenter = TeamPresenter(
                baseURL: leaguesDetailsPresenter.getBaseURL(),
                teamId: teamId
            )
            vc.presenter = presenter
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    private func makeEmptyCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath,
        icon: String,
        message: String
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath)
        cell.contentView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }

        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        let iconView = UIImageView(image: UIImage(systemName: icon, withConfiguration: config))
        iconView.tintColor = UIColor(red: 0.18, green: 0.42, blue: 0.92, alpha: 0.35)
        iconView.contentMode = .scaleAspectFit

        let label = UILabel()
        label.text = message
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .tertiaryLabel
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.tag = 999
        stack.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),
        ])
        return cell
    }
}


extension LeaguesDetailsCollectionViewController: SectionHeaderDelegate {
    func sectionHeader(_ header: SectionHeaderView, didSelectSegmentAt index: Int) {
        currentItemSegment = index
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.reloadSections(IndexSet(integer: 2))
    }
}


extension LeaguesDetailsCollectionViewController: LeaguesDetailsView {

    func showLoading() {
        guard shimmerOverlay == nil else { return }
        let overlay = ShimmerOverlayView(frame: collectionView.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.addSubview(overlay)
        shimmerOverlay = overlay
    }

    func hideLoading() {
        shimmerOverlay?.stopShimmer()
        shimmerOverlay?.removeFromSuperview()
        shimmerOverlay = nil
    }

    func showData() {
        animatedCells.removeAll()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.reloadData()
    }

    func showEmptyState() {
        collectionView.reloadData()
    }

    func showError(message: String) {
        print("Error:", message)
    }

    func updateFavoriteButton(isFavorite: Bool) {
        guard let button = favoriteButton?.customView as? UIButton else { return }
        updateFavoriteButtonIcon(button, isFavorite: isFavorite)
    }
    func showNoInternet() {

            NetworkMonitor.shared.showNoInternet(on: self)
        }
    
}
