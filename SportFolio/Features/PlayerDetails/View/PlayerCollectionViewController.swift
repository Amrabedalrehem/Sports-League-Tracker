//
//  PlayerCollectionViewController.swift
//  SportFolio
//
//  Created by Shahd Ashraf on 15/05/2026.
//

import UIKit
import SkeletonView

private let reuseIdentifier = "PlayerViewCell"

final class PlayerCollectionViewController: UICollectionViewController {




	var presnter : PlayerPresenterProtocol!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
		presnter.getPlayer()

	}



	private func setupCollectionView() {


		collectionView.backgroundColor = .appBackground
		collectionView.isSkeletonable = true
		collectionView.register(
			UINib(
				nibName: reuseIdentifier,
				bundle: nil
			),
			forCellWithReuseIdentifier: reuseIdentifier
		)
	}



	private static func createLayout() -> UICollectionViewCompositionalLayout {

		UICollectionViewCompositionalLayout { _, _ in

			let itemSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(1.0)
			)

			let item = NSCollectionLayoutItem(layoutSize: itemSize)

			let groupSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .absolute(320)
			)

			let group = NSCollectionLayoutGroup.vertical(
				layoutSize: groupSize,
				subitems: [item]
			)

			group.contentInsets = NSDirectionalEdgeInsets(
				top: 12,
				leading: 16,
				bottom: 12,
				trailing: 16
			)

			let section = NSCollectionLayoutSection(group: group)

			return section
		}
	}



	override func numberOfSections(
		in collectionView: UICollectionView
	) -> Int {

		return 1
	}

	override func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {

		return presnter.getPlayerData() == nil ? 0 : 1
	}

	override func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: reuseIdentifier,
			for: indexPath
		) as! PlayerViewCell

		guard let player = presnter.getPlayerData() else {
			return cell
		}

		cell.hideSkeleton()

		cell.configure(with: player)

		return cell
	}



	
}
extension PlayerCollectionViewController: PlayerView {

	func showLoading() {

		collectionView.showAnimatedGradientSkeleton()
	}

	func hideLoading() {

		collectionView.hideSkeleton()
	}

	func showPlayer() {

		collectionView.reloadData()
	}

	func showEmptyState() {

		showWhenEmpty(
			iconText: "person.crop.circle.badge.exclamationmark",
			titleText: L10n.emptyPlayerTitle,
			subtitleText: L10n.emptyPlayerSubtitle
		)

	}

	func showError(message: String) {

		print(message)
	}

	func showNoInternet() {

		NetworkMonitor.shared.showNoInternet(on: self)
	}
}
