//
//  Untitled.swift
//  SportFolio
//
//  Created by Shahudaa on 08/05/2026.
//


import Foundation
@testable import SportFolio

final class MockNetworkService: NetworkService {

    var shouldReturnError = false

    func getLeagues(
        baseURL: String,
        completion: @escaping (Result<LeaguesResponse, Error>) -> Void
    ) {

        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 404)))
            return
        }

        let mockLeague = LeagueModel(
            leagueKey: 1,
            leagueName: "Premier League",
            leagueLogo: nil,
            countryKey: 44,
            countryName: "England",
            countryLogo: nil
        )

        let response = LeaguesResponse(
            success: 1,
            result: [mockLeague]
        )

        completion(.success(response))
    }

    

    func getEvents(
        baseURL: String,
        leagueId: Int,
        from: String,
        to: String,
        completion: @escaping (Result<EventsResponse, Error>) -> Void
    ) {

        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 404)))
            return
        }

        let mockEvent = EventModel(
            eventKey: 1,
            eventDate: "2026-05-08",
            eventTime: "20:00",
            eventHomeTeam: "Liverpool",
            eventAwayTeam: "Arsenal",
            homeTeamKey: 1,
            awayTeamKey: 2,
            eventFinalResult: "2-1",
            eventStatus: "Finished",
            homeTeamLogo: "",
            awayTeamLogo: "",
            leagueName: "Premier League",
            leagueKey: 1,
            leagueLogo: ""
        )

        let response = EventsResponse(
            success: 1,
            result: [mockEvent]
        )

        completion(.success(response))
    }

 

    func getTeams(
        baseURL: String,
        leagueId: Int,
        completion: @escaping (Result<TeamsResponse, Error>) -> Void
    ) {

        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 404)))
            return
        }

        let mockTeam = TeamModel(
            teamKey: 1,
            teamName: "Liverpool",
            teamLogo: "",
            players: nil
        )

        let response = TeamsResponse(
            success: 1,
            result: [mockTeam]
        )

        completion(.success(response))
    }

    

    func getTeamDetails(
        baseURL: String,
        teamId: Int,
        completion: @escaping (Result<TeamsResponse, Error>) -> Void
    ) {

        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 404)))
            return
        }

        let mockPlayer = PlayerModel(
            playerKey: 10,
            playerName: "Mohamed Salah",
            playerNumber: "11",
            playerCountry: "Egypt",
            playerType: "Forward",
            playerAge: "33",
            playerImage: "",
            playerLogo: "",
            teamName: "Liverpool",
            teamKey: 1,
            playerMinutes: "90",
            playerBirthdate: "1992-06-15",
            playerIsCaptain: "No"
        )

        let mockTeam = TeamModel(
            teamKey: 1,
            teamName: "Liverpool",
            teamLogo: "",
            players: [mockPlayer]
        )

        let response = TeamsResponse(
            success: 1,
            result: [mockTeam]
        )

        completion(.success(response))
    }

   

    func getPlayers(
        baseURL: String,
        leagueId: Int,
        completion: @escaping (Result<PlayerResponse, Error>) -> Void
    ) {

        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 404)))
            return
        }

        let mockPlayer = PlayerModel(
            playerKey: 10,
            playerName: "Mohamed Salah",
            playerNumber: "11",
            playerCountry: "Egypt",
            playerType: "Forward",
            playerAge: "33",
            playerImage: "",
            playerLogo: "",
            teamName: "Liverpool",
            teamKey: 1,
            playerMinutes: "90",
            playerBirthdate: "1992-06-15",
            playerIsCaptain: "No"
        )

        let response = PlayerResponse(
            success: 1,
            result: [mockPlayer]
        )

        completion(.success(response))
    }
}
