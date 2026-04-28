//
//  APIConstants.swift
//  SportFolio
//
//  Created by ITI_JETS on 28/04/2026.
//


import Foundation

struct APIConstants {
    
    static let apiKey = "d8ac069ebc43e11124af0fee2e8fb82b4a99118799c5f43fec33cfd7c382dc1d"
    static let baseUrl = "https://apiv2.allsportsapi.com/"
    struct BaseURL {
        static let football   = "\(baseUrl)football/"
        static let basketball = "\(baseUrl)basketball/"
        static let cricket    = "\(baseUrl)cricket/"
        static let tennis     = "\(baseUrl)tennis/"
    }
}
