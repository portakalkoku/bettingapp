//
//  OddCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 25.04.2022.
//

import UIKit

class OddCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 5.0
            containerView.clipsToBounds = true
            containerView.layer.borderColor = UIColor.black.cgColor
            containerView.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var indicatorView: UIView! {
        didSet {
            indicatorView.clipsToBounds = true
            indicatorView.layer.cornerRadius = 5.0
            indicatorView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    @IBOutlet weak var oddLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    func reloadWith(odd: BulletinModels.OddCellModel) {
        switch odd.type {
        case .draw:
            indicatorLabel.text = "X"
        case .away:
            indicatorLabel.text = "2"
        case .home:
            indicatorLabel.text = "1"
        }
        
        if odd.selected {
            containerView.backgroundColor = .orange
            indicatorLabel.textColor = .white
            oddLabel.textColor = .white
        } else {
            containerView.backgroundColor = .clear
            indicatorLabel.textColor = .black
            oddLabel.textColor = .black
        }
        
        oddLabel.text = "\(odd.price)"
    }
}
