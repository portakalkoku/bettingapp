//
//  CartContentView.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import Foundation
import UIKit

protocol CartContentDelegate: AnyObject {
    func didTapCheckout()
}

class CartContentView: UIView {
    @IBOutlet weak var multiplierLabel: UILabel!
    weak var delegate: CartContentDelegate?
    func reloadMultiplier(multiplier: Double) {
        multiplierLabel.text = String(format: "%.2f", multiplier)
    }
    @IBAction func didTapCheckout(_ sender: Any) {
        delegate?.didTapCheckout()
    }
}
