//
//  CheckoutViewController+Build.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import Foundation
import UIKit

extension CheckoutViewController {
    static func build(cart: Cart) -> UIViewController {
        let viewModel: CheckoutViewModel = CheckoutViewModel.init(cart: cart)
        let cartViewController: CheckoutViewController = .init(viewModel: viewModel)
        viewModel.delegate = cartViewController
        return cartViewController
    }
}
