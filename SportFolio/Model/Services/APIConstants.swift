//
//  APIConstants.swift
//  SportFolio
//
//  Created by ITI_JETS on 28/04/2026.
//


import Foundation

struct APIConstants {
    
    static let apiKey = "461d44772f3080859d35ecaa733f35c295f4eacbbea318188a89aa927a037ee9"
    static let baseUrl = "https://apiv2.allsportsapi.com/"
    struct BaseURL {
        static let football   = "\(baseUrl)football/"
        static let basketball = "\(baseUrl)basketball/"
        static let cricket    = "\(baseUrl)cricket/"
        static let tennis     = "\(baseUrl)tennis/"
    }
}
