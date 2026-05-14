//
//  L10n.swift
//  SportFolio


import Foundation

// MARK: - Shorthand helper

private func l(_ key: String) -> String {
    NSLocalizedString(key, comment: "")
}

// MARK: - L10n

enum L10n {

    // MARK: Navigation
    static let navSportfolio = l("nav.sportfolio")
    static let navHome       = l("nav.home")
    static let navFavorites  = l("nav.favorites")
    static let navLeagues    = l("nav.leagues")
    static let navTeam       = l("nav.team")

    // MARK: Sport Names
    static let sportFootball   = l("sport.football")
    static let sportBasketball = l("sport.basketball")
    static let sportCricket    = l("sport.cricket")
    static let sportTennis     = l("sport.tennis")

    // MARK: Search
    static let searchPlaceholder = l("search.placeholder")

    // MARK: Alert — General
    static let alertOK     = l("alert.ok")
    static let alertCancel = l("alert.cancel")
    static let alertDelete = l("alert.delete")
    static let alertErrorTitle = l("alert.error.title")

    // MARK: Alert — Favorites
    static let alertRemoveFavoriteTitle   = l("alert.removeFavorite.title")
    static let alertRemoveFavoriteMessage = l("alert.removeFavorite.message")

    // MARK: Empty States
    static let emptyLeaguesTitle    = l("empty.leagues.title")
    static let emptyLeaguesSubtitle = l("empty.leagues.subtitle")

    static let emptyFavoritesTitle    = l("empty.favorites.title")
    static let emptyFavoritesSubtitle = l("empty.favorites.subtitle")

    static let emptyTeamTitle    = l("empty.team.title")
    static let emptyTeamSubtitle = l("empty.team.subtitle")

    // MARK: Team Sections
    static let teamSectionGoalkeepers = l("team.section.goalkeepers")
    static let teamSectionDefenders   = l("team.section.defenders")
    static let teamSectionMidfielders = l("team.section.midfielders")
    static let teamSectionForwards    = l("team.section.forwards")

    // MARK: Team — Player Card
    static let playerAgePrefix   = l("player.age.prefix")  
    static let playerAgeUnknown  = l("player.age.unknown")  
    static let playerNameUnknown = l("player.name.unknown")
    static let teamNameUnknown   = l("team.name.unknown")

    // MARK: Empty State — Team Squad
    static let emptySquadTitle    = l("empty.squad.title")
    static let emptySquadSubtitle = l("empty.squad.subtitle")

    // MARK: Section Headers — League Details
    static let sectionUpcomingMatches = l("section.upcomingMatches")
    static let sectionLatestMatches   = l("section.latestMatches")
    static let sectionTeams           = l("section.teams")
    static let sectionPlayers         = l("section.players")

    // MARK: Empty States — League Details
    static let emptyUpcomingMatches = l("empty.upcomingMatches")
    static let emptyLatestMatches   = l("empty.latestMatches")
    static let emptyTeams           = l("empty.teams")
    static let emptyPlayers         = l("empty.players")

    // MARK: Splash Screen
    static let splashTagline = l("splash.tagline")

    // MARK: No Internet
    static let noInternetTitle   = l("noInternet.title")
    static let noInternetMessage = l("noInternet.message")
    static let noInternetRetry   = l("noInternet.retry")
    static let noInternetDismiss = l("noInternet.dismiss")
    
    
    // MARK: Onboarding
    static let onboardingPage1Title       = l("onboarding.page1.title")
    static let onboardingPage1Description = l("onboarding.page1.description")

    static let onboardingPage2Title       = l("onboarding.page2.title")
    static let onboardingPage2Description = l("onboarding.page2.description")

    static let onboardingPage3Title       = l("onboarding.page3.title")
    static let onboardingPage3Description = l("onboarding.page3.description")
    
    static let onboardingNext = l("onboarding.next")
    static let onboardingGetStarted = l("onboarding.getStarted")


	// MARK: player
	static let playerAge = l("player.age")
	static let captain = l("player.captain")
	static let unknown = l("common.unknown")
	static let playerStatRating = l("player.stat.rating")
	static let playerStatMinutes = l("player.stat.minutes")
	static let playerStatPlayed = l("player.stat.played")
	static let playerStatGConc = l("player.stat.gconc")
	static let playerStatSaves = l("player.stat.saves")

}
