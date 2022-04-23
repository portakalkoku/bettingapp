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
    
    var parameters: [String: String] {
        switch self {
        case .sports:
            return ["all": "false"]
        }
    }
    
    var url: String {
        switch self {
        case .sports:
            return "sports"
        }
    }
}

