//
//  LeaguesDetailsCollectionViewController+Extensions.swift
//  SportFolio
// created by shahudaaaa

import UIKit

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
