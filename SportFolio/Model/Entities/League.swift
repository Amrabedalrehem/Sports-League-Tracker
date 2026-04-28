//
//  LeaguesResponse.swift
//  SportFolio
//
//  Created by ITI_JETS on 28/04/2026.
//

import Foundation

struct LeaguesResponse: Codable {
    let success: Int?
    let result: [LeagueModel]?
}

struct LeagueModel: Codable {
    let leagueKey:   Int?
    let leagueName:  String?
    let leagueLogo:  String?
    let countryKey:  Int?
    let countryName: String?
    let countryLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey   = "league_key"
        case leagueName  = "league_name"
        case leagueLogo  = "league_logo"
        case countryKey  = "country_key"
        case countryName = "country_name"
        case countryLogo = "country_logo"
    }
}
