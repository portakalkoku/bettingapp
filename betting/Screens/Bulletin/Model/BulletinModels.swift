//
//  BulletinSportsModel.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import Foundation

enum BulletinModels {
    struct Sport: Codable{
        let key: String
        let group: String
        let title: String
        let description: String
        let active: Bool
    }
}

enum PredefinedSports: String, Codable {
    case soccer = "Soccer"
    case basketball = "Basketball"
    case baseball = "Baseball"
    case americanFootball = "American Football"
}
