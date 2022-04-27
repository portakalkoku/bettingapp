//
//  CartContentView.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import Foundation
import UIKit

class CartContentView: UIView {
    @IBOutlet weak var multiplierLabel: UILabel!
    override func awakeFromNib() {
    }
    
    func reloadMultiplier(multiplier: Double) {
        multiplierLabel.text = "\(multiplier)"
    }
}