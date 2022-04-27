//
//  BulletinViewController+Build.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import Foundation
import UIKit

extension BulletinViewController {
    class func build(api: API) -> UIViewController {
        let firebaseHelper: FirebaseHelperProtocol = FirebaseHelper()
        let cart: Cart = Cart()
        cart.firebaseHelper = firebaseHelper
        let viewModel = BulletinViewModel(api: api, cart: cart)
        let router: BulletinRouter = BulletinRouter()
        let viewController = BulletinViewController(viewModel: viewModel, router: router)
        viewModel.delegate = viewController
        viewModel.firebaseHelper = firebaseHelper
        router.viewController = viewController
        return viewController
    }
}
