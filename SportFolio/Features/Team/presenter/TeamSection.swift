//
//  TeamSection.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//


import UIKit

enum TeamSection: Int, CaseIterable {
    case goalkeepers
    case defenders
    case midfielders
    case forwards

    var title: String {
        switch self {
        case .goalkeepers: return L10n.teamSectionGoalkeepers
        case .defenders:   return L10n.teamSectionDefenders
        case .midfielders: return L10n.teamSectionMidfielders
        case .forwards:    return L10n.teamSectionForwards
        }
    }

    var icon: String {
        switch self {
        case .goalkeepers: return "🧤"
        case .defenders: return "🛡️"
        case .midfielders: return "⚽"
        case .forwards: return "⚡"
        }
    }

    var badgeText: String {
        switch self {
        case .goalkeepers: return "GK"
        case .defenders: return "DEF"
        case .midfielders: return "MID"
        case .forwards: return "FWD"
        }
    }

    var badgeColor: UIColor {
        switch self {
        case .goalkeepers: return .goalkeeperBadge
        case .defenders: return UIColor.systemGreen
        case .midfielders: return UIColor.systemBlue
        case .forwards: return UIColor.systemRed
        }
    }
}