//
//  PlayerDetailsPresnter.swift
//  SportFolio
//
//  Created by Shahd Ashraf on 14/05/2026.
//

import Foundation



protocol PlayerPresenterProtocol {
	func getPlayer()
	func getPlayerData()-> PlayerModel?
	func getStats()-> [PlayerStat]
	func getTournaments()-> [Tournament]
	func numberOfItems(in section: PlayerSection) -> Int
}



final class PlayerPresenter: PlayerPresenterProtocol {

	weak var view: PlayerView?

	private let network:   NetworkService
	private let baseURL:   String
	private let playerKey: Int

	private var player: PlayerModel?

	init(
		network:   NetworkService,
		baseURL:   String,
		playerKey: Int,
		view:      PlayerView
	) {
		self.network   = network
		self.baseURL   = baseURL
		self.playerKey = playerKey
		self.view      = view
	}



	func getPlayer() {
		view?.showLoading()

		network.getPlayerDetails(
			baseURL:  baseURL,
			playerId: playerKey
		) { [weak self] result in

			guard let self else { return }

			DispatchQueue.main.async {
				self.view?.hideLoading()

				switch result {
					case .success(let response):
						guard let player = response.result?.first else {
							self.view?.showEmptyState()
							return
						}
						self.player = player
						self.view?.showPlayer()

					case .failure(let error):
						self.view?.showError(message: error.localizedDescription)
				}
			}
		}
	}



	func getPlayerData() -> PlayerModel? { player }

	func getStats() -> [PlayerStat] { player?.stats ?? [] }

	func getTournaments() -> [Tournament] { player?.tournaments ?? [] }

	func numberOfItems(in section: PlayerSection) -> Int {
		switch section {
			case .hero:        return 1
			case .seasonStats: return getStats().count
			case .tournaments: return getTournaments().count
		}
	}
}
