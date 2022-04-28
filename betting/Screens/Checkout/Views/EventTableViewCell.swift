//
//  EventTableViewCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 27.04.2022.
//

import UIKit
protocol EventTableViewCellDelegate: AnyObject {
    func didTapRemoveEventFromCart(event: CartModels.Event)
}

class EventTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var matchNameLabel: UILabel!
    @IBOutlet weak var oddLabel: UILabel!
    @IBOutlet weak var ratioLabel: UILabel!
    @IBOutlet weak var removeFromCart: UIButton!
    
    private var event: CartModels.Event?
    weak var delegate: EventTableViewCellDelegate?
    
    func reloadWith(event: CartModels.Event) {
        self.event = event
        matchNameLabel.text = event.name
        switch event.side {
        case .away:
            oddLabel.text = "2"
        case .draw:
            oddLabel.text = "0"
        case .home:
            oddLabel.text = "1"
        }
        ratioLabel.text = "\(event.price)"
    }
    
    // MARK: - IBActions
    @IBAction func removeEventFromCart(_ sender: Any) {
        guard let event = event else { return }
        delegate?.didTapRemoveEventFromCart(event: event)
    }
}
