//
//  FirebaseHelper.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 28.04.2022.
//

import Foundation
import Firebase

protocol FirebaseHelperProtocol {
    func sendEvent(_ event: String, parameters: [String: Any]?)
}

class FirebaseHelper {
    static func build() {
        FirebaseApp.configure()
    }
}

extension FirebaseHelper: FirebaseHelperProtocol {
    func sendEvent(_ event: String, parameters: [String: Any]?) {
        Analytics.logEvent(event, parameters: parameters)
    }
}
