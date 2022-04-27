//
//  CartModels.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import Foundation

class CartModels {
    struct Event {
        let id: String
        let name: String
        let price: Double
        let side: BulletinModels.OddType
    }
}
