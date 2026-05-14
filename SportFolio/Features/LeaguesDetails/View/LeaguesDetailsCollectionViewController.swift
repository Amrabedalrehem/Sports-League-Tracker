//
//  LeaguesDetailsCollectionViewController.swift
//  SportFolio
// created by shahudaaaa

import UIKit
import SDWebImage
  
 let teamCellId     = "TeamCollectionViewCell"
 let upComingCellId = "UpcomingEventCollectionViewCell"
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
    var favoriteButton: UIBarButtonItem?
    var currentItemSegment: Int = 0
    var shimmerOverlay: ShimmerOverlayView?
    var animatedCells: Set<IndexPath> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupNavigationBar()
        setupCollectionView()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        leaguesDetailsPresenter.loadAllData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          applyNavBarAppearance()
    }

    private func applyNavBarAppearance() {
     let appearance = UINavigationBarAppearance()
     appearance.configureWithOpaqueBackground()
     appearance.backgroundColor   = .tabBarGradientStart
     appearance.shadowColor       = .clear

     let titleAttrs: [NSAttributedString.Key: Any] = [
         .foregroundColor: UIColor.white,
         .font: UIFont.systemFont(ofSize: 18, weight: .bold)
     ]
     appearance.titleTextAttributes = titleAttrs

     navigationController?.navigationBar.standardAppearance    = appearance
     navigationController?.navigationBar.scrollEdgeAppearance  = appearance
     navigationController?.navigationBar.compactAppearance     = appearance
     navigationController?.navigationBar.tintColor             = .white
 }
   
    private func setupBackground() {
        collectionView.backgroundColor = .appBackground
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

        let isCurrentlyFavorite = leaguesDetailsPresenter.isFavorite()

        if isCurrentlyFavorite {

            AlertManager.showDeleteConfirmation(on: self) { [weak self] in
                guard let self = self else { return }

                UIView.animate(withDuration: 0.2) {
                    button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                } completion: { _ in
                    UIView.animate(withDuration: 0.2) {
                        button.transform = .identity
                    }
                }

                let isFavorite = self.leaguesDetailsPresenter.toggleFavorite()

                self.updateFavoriteButtonIcon(button, isFavorite: isFavorite)

                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }

        } else {

            UIView.animate(withDuration: 0.2) {
                button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    button.transform = .identity
                }
            }

            let isFavorite = leaguesDetailsPresenter.toggleFavorite()

            updateFavoriteButtonIcon(button, isFavorite: isFavorite)

            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }

    func updateFavoriteButtonIcon(_ button: UIButton, isFavorite: Bool) {
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

    func makeEmptyCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath,
        icon: String,
        message: String
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellId, for: indexPath)
        cell.contentView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }

        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
        let iconView = UIImageView(image: UIImage(systemName: icon, withConfiguration: config))
        iconView.tintColor = .primaryBlueLight
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
