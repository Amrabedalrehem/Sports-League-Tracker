//
//  PlayerModel.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 28/04/2026.
//
//

struct PlayerResponse: Codable {
	let success: Int?
	let result: [PlayerModel]?
}

struct PlayerModel: Codable {
	let playerKey:           Int?
	let playerName:          String?
	let playerNumber:        String?
	let playerCountry:       String?
	let playerType:          String?
	let playerAge:           String?
	let playerImage:         String?
	let playerLogo:          String?
	let teamName:            String?
	let teamKey:             Int?
	let playerMinutes:       String?
	let playerBirthdate:     String?
	let playerIsCaptain:     String?
	let playerMatchPlayed:   String?
	let playerGoalsConceded: String?
	let playerSaves:         String?
	let playerRating:        String?
	let stats:               [PlayerStat]?
	let tournaments:         [Tournament]?

	enum CodingKeys: String, CodingKey {
		case playerKey           = "player_key"
		case playerName          = "player_name"
		case playerNumber        = "player_number"
		case playerCountry       = "player_country"
		case playerType          = "player_type"
		case playerAge           = "player_age"
		case playerImage         = "player_image"
		case playerLogo          = "player_logo"
		case teamName            = "team_name"
		case teamKey             = "team_key"
		case playerMinutes       = "player_minutes"
		case playerBirthdate     = "player_birthdate"
		case playerIsCaptain     = "player_is_captain"
		case playerMatchPlayed   = "player_match_played"
		case playerGoalsConceded = "player_goals_conceded"
		case playerSaves         = "player_saves"
		case playerRating        = "player_rating"
		case stats
		case tournaments
	}

	var isTennis: Bool {
		playerType?.lowercased() == "tennis"
	}


	var avatarURL: String? {
		isTennis
		? (playerLogo ?? playerImage)
		: (playerImage ?? playerLogo)
	}
}



struct PlayerStat: Codable {
	let season:      String?
	let type:        String?
	let rank:        String?
	let titles:      String?
	let matchesWon:  String?
	let matchesLost: String?
	let hardWon:     String?
	let hardLost:    String?
	let clayWon:     String?
	let clayLost:    String?
	let grassWon:    String?
	let grassLost:   String?

	enum CodingKeys: String, CodingKey {
		case season
		case type
		case rank
		case titles
		case matchesWon  = "matches_won"
		case matchesLost = "matches_lost"
		case hardWon     = "hard_won"
		case hardLost    = "hard_lost"
		case clayWon     = "clay_won"
		case clayLost    = "clay_lost"
		case grassWon    = "grass_won"
		case grassLost   = "grass_lost"
	}


	func wl(won: String?, lost: String?) -> String? {
		guard won != nil || lost != nil else { return nil }
		return "\(won ?? "-") / \(lost ?? "-")"
	}

	var overallWL:  String? { wl(won: matchesWon,  lost: matchesLost) }
	var hardWL:     String? { wl(won: hardWon,      lost: hardLost)   }
	var clayWL:     String? { wl(won: clayWon,      lost: clayLost)   }
	var grassWL:    String? { wl(won: grassWon,     lost: grassLost)  }
}


struct Tournament: Codable {
	let name:    String?
	let season:  String?
	let type:    String?
	let surface: String?
	let prize:   String?
}


enum PlayerSection: Int, CaseIterable {
	case hero        = 0
	case seasonStats = 1
	case tournaments = 2
}
