//
//  OddCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 25.04.2022.
//

import UIKit

class OddCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 5.0
            containerView.clipsToBounds = true
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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
