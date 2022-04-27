//
//  Cart.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import RxCocoa

class Cart {
    var events: BehaviorRelay<[CartModels.Event]> = .init(value: [])
    var firebaseHelper: FirebaseHelperProtocol?
    
    func addOrRemoveEvent(_ event: CartModels.Event) {
        var events = self.events.value
        if let index = events.firstIndex(where: {$0.id == event.id}) {
            firebaseHelper?.sendEvent("remove_event", parameters: ["id": event.id])
            events.remove(at: index)
        } else {
            firebaseHelper?.sendEvent("add_event", parameters: ["id": event.id])
            events.append(event)
        }
        self.events.accept(events)
    }
    
    func checkIfOddExistInCart(_ id: String, type: BulletinModels.OddType) -> Bool {
        let events = self.events.value
        return events.firstIndex(where: {$0.id == id && $0.side == type }) != nil
    }
    
    func getMultiplier() -> Double {
        var multiplier = 1.0
        events.value.forEach { event in
            multiplier = multiplier * event.price
        }
        return multiplier
    }
}
