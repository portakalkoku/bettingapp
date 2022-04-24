//
//  API+Odds.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import Foundation
import Alamofire

enum RequestType: TargetType {
    
    case sports
    case odds(key: String)
    
    var parameters: [String: String] {
        switch self {
        case .sports:
            return ["all": "false"]
        case .odds:
            return ["regions": "eu"]
        }
    }
    
    var url: String {
        switch self {
        case .sports:
            return "sports"
        case let .odds(key):
            return "sports/\(key)/odds"
        }
    }
}

