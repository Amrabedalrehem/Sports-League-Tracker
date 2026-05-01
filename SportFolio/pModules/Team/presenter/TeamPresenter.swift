//
//  TeamPresenter.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//
import Foundation

protocol TeamView: AnyObject {
    func reloadData()
    func startAnimating()
    func stopAnimating()
    func showError(message: String)
}

final class TeamPresenter {

    weak var view: TeamView?

    private var team: TeamModel?
    private var players: [PlayerModel] = []

    var baseURL: String = ""
    var teamId: Int = 0

    func attachView(_ view: TeamView) {
        self.view = view
    }

    func fetchTeamDetails() {
        view?.startAnimating()

        NetworkServiceImpl.shared.getTeamDetails(
            baseURL: baseURL,
            teamId: teamId
        ) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.view?.stopAnimating()

                switch result {
                case .success(let response):
                    self.team = response.result?.first
                    self.players = self.team?.players ?? []
                    self.view?.reloadData()

                case .failure(let error):
                    self.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    func getTeamName() -> String {
        team?.teamName ?? ""
    }

    func getTeamLogo() -> String {
        team?.teamLogo ?? ""
    }

    private func normalizedPlayers(for type: String) -> [PlayerModel] {
        players.filter { ($0.playerType ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == type.lowercased() }
    }

    func getGoalkeepers() -> [PlayerModel] {
        normalizedPlayers(for: "Goalkeepers")
    }

    func getDefenders() -> [PlayerModel] {
        normalizedPlayers(for: "Defenders")
    }

    func getMidfielders() -> [PlayerModel] {
        normalizedPlayers(for: "Midfielders")
    }

    func getForwards() -> [PlayerModel] {
        normalizedPlayers(for: "Forwards")
    }
}
