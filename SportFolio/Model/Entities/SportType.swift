//
//  SportType.swift
//  SportFolio
//
//  Created by ITI_JETS on 30/04/2026.
//

enum SportType {
    case football
    case basketball
    case cricket
    case tennis
}

extension SportType {
    var baseURL: String {
        switch self {
        case .football:
            return APIConstants.BaseURL.football
        case .basketball:
            return APIConstants.BaseURL.basketball
        case .cricket:
            return APIConstants.BaseURL.cricket
        case .tennis:
            return APIConstants.BaseURL.tennis
        }
    }
}
