//
//  Standing.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 05/05/2026.
//


struct Standing {

    let position: Int
    let team: String
    let played: Int
    let won: Int
    let drawn: Int
    let lost: Int
    let points: Int
    let promotionType: String?
    let logo: String

}

struct StandingsData {

    let total: [Standing]
    let home: [Standing]
    let away: [Standing]
    let season: String

}
