//
//  AppDelegate.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 23.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseHelper.build()
        return true
    }
}

