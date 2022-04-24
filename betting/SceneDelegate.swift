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
        navigationController.navigationBar.topItem?.title = "Best Bet"
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        window?.rootViewController = navigationController
    }
}

