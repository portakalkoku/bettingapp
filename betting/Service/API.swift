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
