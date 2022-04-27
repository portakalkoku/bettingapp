//
//  API.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 23.04.2022.
//

import Alamofire

public protocol TargetType {
    var url: String  { get }
    var parameters: [String: String] { get }
}

class API {
    
    private var baseUrl: URL {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let dictionaryList = NSDictionary(contentsOfFile: path),
           let apiUrl = dictionaryList["API_URL"] as? String, let url = URL(string: apiUrl) {
            return url
        } else {
            fatalError("the api url must be registered into info-plist file as an API_URL key")
        }
    }
    
    private var apiKey: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let dictionaryList = NSDictionary(contentsOfFile: path),
           let apiKey = dictionaryList["API_KEY"] as? String {
            return apiKey
        } else {
            fatalError("the api url must be registered into info-plist file as an API_URL key")
        }
    }
}
extension API {
     func request(type: TargetType, completion: @escaping (Result<Data, APIError>) -> ()) {
        let urlEncoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(), destination: .queryString)
        
        var parameters = type.parameters
        parameters["apiKey"] = apiKey
        
        let url = baseUrl.appendingPathComponent(type.url)
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoder: urlEncoder).validate().responseData { response in
            switch response.result {
            case .success(let data):
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
