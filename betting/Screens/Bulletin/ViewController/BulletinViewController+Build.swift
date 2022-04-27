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
        let viewModel = BulletinViewModel(api: api, cart: Cart())
        let router: BulletinRouter = BulletinRouter()
        let viewController = BulletinViewController(viewModel: viewModel, router: router)
        viewModel.delegate = viewController
        router.viewController = viewController
        return viewController
    }
}
