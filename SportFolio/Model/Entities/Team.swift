//
//  TeamsResponse.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 28/04/2026.
//


import Foundation

struct TeamsResponse: Codable {
    let success: Int?
    let result: [TeamModel]?
}

struct TeamModel: Codable {
    let teamKey:  Int?
    let teamName: String?
    let teamLogo: String?
    let players:  [PlayerModel]?

    enum CodingKeys: String, CodingKey {
        case teamKey  = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players  = "players"
    }
}