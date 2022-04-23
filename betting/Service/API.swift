//
//  API.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 23.04.2022.
//

import Foundation
public protocol TargetType {
    var url: String  { get }
    var parameters: [String: String] { get }
}

extension API {
    class func request(type: TargetType, completion: @escaping (Result<Data, APIError>) -> ()) {
        let urlEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(), destination: .queryString)
        
        var parameters = type.parameters
        parameters["apiKey"] = sharedInstance.apiKey
        
        let url = sharedInstance.baseUrl.appendingPathComponent(type.url)
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoder: urlEncoder).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let dataStr = String(decoding: data, as: UTF8.self)
                print("⏩\(dataStr)")
                completion(.success(data))
            case .failure(_):
                completion(.failure(.serviceError))
            }
        }
    }
}
enum APIError: Error {
    case wrongMapping
    case serviceError
}
