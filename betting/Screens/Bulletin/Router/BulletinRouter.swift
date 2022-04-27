//
//  BulletinRouter.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import UIKit
protocol BulletinRouting {
    func routeToCheckout(with cart: Cart)
}

class BulletinRouter: BulletinRouting {
    weak var viewController: BulletinViewController?
    
    func routeToCheckout(with cart: Cart) {
        viewController?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
