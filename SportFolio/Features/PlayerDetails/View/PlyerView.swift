//
//  view.swift
//  SportFolio
//
//  Created by Shahd Ashraf on 15/05/2026.
//

protocol PlayerView: AnyObject {

	func showLoading()
	func hideLoading()
	func showPlayer()
	func showEmptyState()
	func showError(message: String)
	func showNoInternet()
}
