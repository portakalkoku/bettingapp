//
//  UIFont+Extensions.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 26.04.2022.
//

import UIKit

enum Fonts: String {
    case futuraBold = "futura-bold"
    case futuraMedium = "futura-medium"
}

extension UIFont {
    
    static func customFont(name: Fonts , size: CGFloat) -> UIFont {
        if let font = UIFont(name: name.rawValue, size: size) {
            return font
        }
        else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

