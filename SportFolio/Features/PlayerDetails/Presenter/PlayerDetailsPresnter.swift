//
//  PlayerDetailsPresnter.swift
//  SportFolio
//
//  Created by Shahd Ashraf on 14/05/2026.
//

import Foundation
protocol PlayerPresenterProtocol
{
	//func getPlayers()

}

class PlayerPresenter: PlayerPresenterProtocol {

	//weak var view: PlayerView?
	private let network: NetworkService
	private let sportType: SportType
	private let playerKey : Int
	init(network: NetworkService,sportType :SportType, playerKey : Int) {
		self.network = network
		self.playerKey = playerKey
		self.sportType = sportType
	}

	/*func getPlayers() {
		network
			.getPlayerDetails(baseURL: sportType.baseURL, playerKey: playerKey, completion:{ [weak self] result in
			guard let self = self else { return }

			switch result {
				case .success(let response):
					self.view?.showPlayers(response.result)

				case .failure(let error):
					self.view?.showError(error.localizedDescription)
			}
		}
	}*/
}
