//
//  SceneDelegate.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 23.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        let viewController = BulletinViewController.build(api: API())
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
    }
}

