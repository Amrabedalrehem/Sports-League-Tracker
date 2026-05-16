//
//  PlayerCollectionViewController.swift
//  SportFolio
//
//  Created by Shahd Ashraf on 15/05/2026.
//

import UIKit
import SkeletonView



private enum ReuseID {
	static let hero       = "PlayerViewCell"
	static let stat       = "PlayerStatCell"
	static let tournament = "TournamentCell"
	static let header     = SectionHeaderView.reuseID
}



final class PlayerCollectionViewController: UICollectionViewController {



	var presenter: PlayerPresenterProtocol!



	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
		presenter.getPlayer()
	}



	private func setupCollectionView() {
		collectionView.collectionViewLayout = makeLayout()
		collectionView.backgroundColor      = .appBackground
		collectionView.isSkeletonable       = true


		collectionView.register(
			UINib(nibName: ReuseID.hero, bundle: nil),
			forCellWithReuseIdentifier: ReuseID.hero
		)


		collectionView.register(
			UINib(nibName: ReuseID.stat, bundle: nil),
			forCellWithReuseIdentifier: ReuseID.stat
		)


		collectionView.register(
			UINib(nibName: ReuseID.tournament, bundle: nil),
			forCellWithReuseIdentifier: ReuseID.tournament
		)


		collectionView.register(
			SectionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: ReuseID.header
		)

		collectionView.register(
			UICollectionViewCell.self,
			forCellWithReuseIdentifier: emptyCellId
		)
	}



	private func makeLayout() -> UICollectionViewCompositionalLayout {

		UICollectionViewCompositionalLayout {
 [weak self] sectionIndex,
 _ in

			guard let section = PlayerSection(rawValue: sectionIndex) else { return nil }

			switch section {

				case .hero:
					let item  = NSCollectionLayoutItem(
						layoutSize: .init(widthDimension: .fractionalWidth(1),
										  heightDimension: .fractionalHeight(1))
					)
					let group = NSCollectionLayoutGroup.vertical(
						layoutSize: .init(widthDimension: .fractionalWidth(1),
										  heightDimension: .absolute(220)),
						subitems: [item]
					)
					group.contentInsets = .init(top: 12, leading: 16, bottom: 4, trailing: 16)
					return NSCollectionLayoutSection(group: group)


				case .seasonStats:
					let itemCount = max(self?.presenter.getStats().count ?? 0, 1)

					let item  = NSCollectionLayoutItem(
						layoutSize: .init(widthDimension: .fractionalWidth(1),
										  heightDimension: .fractionalHeight(1))
					)
					let group = NSCollectionLayoutGroup.horizontal(
						layoutSize: .init(
							widthDimension: .fractionalWidth(0.9),
										  heightDimension: .absolute(itemCount == 0 ? 120 : 230)
),
						subitems: [item]
					)
					let section = NSCollectionLayoutSection(group: group)
					section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
					section.interGroupSpacing           = 12
					section.contentInsets               = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
					section.boundarySupplementaryItems  = [Self.makeHeader()]
					return section


				case .tournaments:

					let itemCount = max(self?.presenter.getTournaments().count ?? 0, 1)

					let item  = NSCollectionLayoutItem(
						layoutSize: .init(widthDimension: .fractionalWidth(1),
										  heightDimension: .fractionalHeight(1))
					)
					let group = NSCollectionLayoutGroup.vertical(
						layoutSize: .init(widthDimension: .fractionalWidth(1),
										  heightDimension: .absolute(
											itemCount == 0 ? 120 : 110
										  )),
						subitems: [item]
					)
					group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
					let section = NSCollectionLayoutSection(group: group)
					section.interGroupSpacing          = 10
					section.contentInsets              = .init(top: 8, leading: 0, bottom: 20, trailing: 0)
					section.boundarySupplementaryItems = [Self.makeHeader()]
					return section
			}
		}
	}

	private static func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: .init(widthDimension: .fractionalWidth(1),
							  heightDimension: .absolute(44)),
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment:   .top
		)
	}


	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		PlayerSection.allCases.count
	}

	override func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {

		guard let s = PlayerSection(rawValue: section) else {
			return 0
		}

		if presenter.getPlayerData() == nil {

			switch s {
				case .hero:
					return 1

				case .seasonStats:
					return 3

				case .tournaments:
					return 4
			}
		}

		let count = presenter.numberOfItems(in: s)

		return count == 0 ? 1 : count
	}

	override func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {

		guard let section = PlayerSection(rawValue: indexPath.section) else {
			return UICollectionViewCell()
		}

		switch section {

			case .hero:
				let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: ReuseID.hero, for: indexPath
				) as! PlayerViewCell

				if let player = presenter.getPlayerData() {
					cell.configure(with: player)
				}
				return cell

			case .seasonStats:

				if presenter.getStats().isEmpty {

					return makeEmptyCell(
						collectionView,
						indexPath: indexPath,
						icon: "chart.bar.xaxis",
						message: L10n.emptyPlayerStats
					)
				}

				let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: ReuseID.stat,
					for: indexPath
				) as! PlayerStatCell

				let stat = presenter.getStats()[indexPath.item]
				cell.configure(with: stat)

				return cell

			case .tournaments:

				if presenter.getTournaments().isEmpty {

					return makeEmptyCell(
						collectionView,
						indexPath: indexPath,
						icon: "trophy",
						message: L10n.emptyPlayerTournaments
					)
				}

				let cell = collectionView.dequeueReusableCell(
					withReuseIdentifier: ReuseID.tournament,
					for: indexPath
				) as! TournamentCell

				let tournament = presenter.getTournaments()[indexPath.item]
				cell.configure(with: tournament)

				return cell
		}
	}

	override func collectionView(
		_ collectionView: UICollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> UICollectionReusableView {

		guard kind == UICollectionView.elementKindSectionHeader,
			  let section = PlayerSection(rawValue: indexPath.section),
			  let header = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: ReuseID.header,
				for: indexPath
			  ) as? SectionHeaderView
		else {
			return UICollectionReusableView()
		}

		switch section {

			case .hero:
				break

			case .seasonStats:
				header.configure(
					title: L10n.playerSectionStats,
					systemIcon: "chart.bar.fill"
				)

			case .tournaments:
				header.configure(
					title: L10n.playerSectionTournaments,
					systemIcon: "trophy.fill"
				)
		}
		return header
	}
}

extension PlayerCollectionViewController: PlayerView {

	func showLoading() {
		let gradient = SkeletonGradient(baseColor: UIColor.clouds)
		collectionView.showAnimatedGradientSkeleton(
			usingGradient: gradient,
			animation:     nil,
			transition:    .crossDissolve(0.25)
		)
	}

	func hideLoading() {
		collectionView.hideSkeleton(transition: .crossDissolve(0.25))
	}

	func showPlayer() {
		collectionView.backgroundView = nil
		collectionView.reloadData()
	}

	func showEmptyState() {
		collectionView.backgroundView = showWhenEmpty(
			iconText:     "person.crop.circle.badge.exclamationmark",
			titleText:    L10n.emptyPlayerTitle,
			subtitleText: L10n.emptyPlayerSubtitle
		)
	}

	func showError(message: String) {
		print("[PlayerVC] Error:", message)

	}

	func showNoInternet() {
		NetworkMonitor.shared.showNoInternet(on: self)
	}
}


extension PlayerCollectionViewController: SkeletonCollectionViewDataSource {

	func numSections(in collectionSkeletonView: UICollectionView) -> Int {
		return PlayerSection.allCases.count
	}

	func collectionSkeletonView(
		_ skeletonView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {

		guard let playerSection = PlayerSection(rawValue: section) else {
			return 0
		}

		switch playerSection {
			case .hero:
				return 1

			case .seasonStats:
				return 3

			case .tournaments:
				return 4
		}
	}

	func collectionSkeletonView(
		_ skeletonView: UICollectionView,
		cellIdentifierForItemAt indexPath: IndexPath
	) -> ReusableCellIdentifier {

		guard let section = PlayerSection(rawValue: indexPath.section) else {
			return ReuseID.hero
		}

		switch section {
			case .hero:
				return ReuseID.hero

			case .seasonStats:
				return ReuseID.stat

			case .tournaments:
				return ReuseID.tournament
		}
	}
}
