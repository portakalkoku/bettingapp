//
//  CheckoutViewModel.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import Foundation

protocol CheckoutViewModelProtocol {
    func getCartEvents() -> [CartModels.Event]
    func removeEventFromCart(event: CartModels.Event)
    func getMultiplier() -> String
    func calculateMaxReturn(value: Double)
}

protocol CheckoutViewModelDelegate: AnyObject {
    func reloadMultiplier(with value: Double)
    func reloadTableView()
    func showEmptyScreen()
}

class CheckoutViewModel {
    weak var delegate: CheckoutViewModelDelegate?
    
    let cart: Cart
    init(
        cart: Cart
    ) {
        self.cart = cart
    }
}

extension CheckoutViewModel: CheckoutViewModelProtocol {
    func removeEventFromCart(event: CartModels.Event) {
        cart.addOrRemoveEvent(event)
        if cart.events.value.count > 0 {
            delegate?.reloadMultiplier(with: cart.getMultiplier())
            delegate?.reloadTableView()
        } else {
            delegate?.showEmptyScreen()
        }
    }
    
    func getCartEvents() -> [CartModels.Event] {
        cart.events.value
    }
    
    func getMultiplier() -> String {
        "\(cart.getMultiplier().convertToTwoDecimalString())"
    }
    
    func calculateMaxReturn(value: Double) {
        let income = value * cart.getMultiplier()
        delegate?.reloadMultiplier(with: income)
    }
}
