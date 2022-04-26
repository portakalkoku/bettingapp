//
//  BulletinSportsModel.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import Foundation
import UIKit

enum BulletinModels {
    struct Sport: Codable {
        let key: String
        let group: String
        let title: String
        let description: String
        let active: Bool
    }
    
    struct GroupCellModel {
        let image: String
        let title: String
        let selected: Bool
    }
    
    struct Odds: Codable {
        let sport_key: String
        let commence_time: String
        let home_team: String
        let away_team: String
        let bookmakers: [Bookmaker]
     
        
        struct Bookmaker: Codable {
            let key: String
            let title: String
            let markets: [Market]
        }
        
        struct Market: Codable {
            let key: String
            let outcomes: [Outcome]
        }
        
        struct Outcome: Codable {
            let name: String
            let price: Double
        }
    }
    
    struct EventCellModel {
        let matchName: String
        let odds: [OddCellModel]
    }
    
}

enum SportType: String, Codable {
    case soccer = "Soccer"
    case basketball = "Basketball"
    case baseball = "Baseball"
    case americanFootball = "American Football"
    case rugby = "Rugby League"
    case golf = "Golf"
    case martialArts = "Mixed Martial Arts"
    case aussieFootball = "Aussie Rules"
    case iceHockey = "Ice Hockey"
    case cricket = "Cricket"
}

extension SportType {
    func getSportIcon() -> String {
        switch self {
        case .soccer:
            return "football"
        case .basketball:
            return "basketball"
        case .baseball:
            return "baseball"
        case .americanFootball:
            return "american-football"
        case .rugby:
            return "rugby"
        case .golf:
            return "golf"
        case .martialArts:
            return "martial-arts"
        case .aussieFootball:
            return "aussie-rules"
        case .iceHockey:
            return "ice-hockey"
        case .cricket:
            return "cricket"
        }
    }
    
}
