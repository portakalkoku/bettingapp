//
//  Double+Extensions.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 28.04.2022.
//

import Foundation

extension Double {
    func convertToTwoDecimalString() -> String {
        return String(format: "%.2f", self)
    }
}
