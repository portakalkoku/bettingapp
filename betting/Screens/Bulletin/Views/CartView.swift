//
//  CartView.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import UIKit

protocol CartViewDelegate: AnyObject {
    func didTapCheckout()
}

class CartView: UIView {
    var cartContentView: CartContentView? = nil
    weak var delegate: CartViewDelegate?
    override func awakeFromNib() {
        isHidden = true
        guard let cartContentView = CartContentView().loadNib() as? CartContentView else { return }
        self.cartContentView = cartContentView
        self.cartContentView?.delegate = self
        self.addSubview(cartContentView)
    }
    
    func reloadViewWith(_ multiplier: Double) {
        if multiplier <= 1.0 {
            isHidden = true
        } else {
            isHidden = false
        }
        cartContentView?.reloadMultiplier(multiplier: multiplier)
    }
}

extension CartView: CartContentDelegate {
    func didTapCheckout() {
        delegate?.didTapCheckout()
    }
}
