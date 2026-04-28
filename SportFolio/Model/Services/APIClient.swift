//
//  APIClient.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 28/04/2026.
//


import Foundation
import Alamofire

class APIClient {
    
    static let shared = APIClient()
    private init() {}
    
     func request<T: Codable>(
        baseURL: String,
        params: [String: Any],
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        var fullParams = params
        fullParams["APIkey"] = APIConstants.apiKey
        
        AF.request(baseURL, parameters: fullParams)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
