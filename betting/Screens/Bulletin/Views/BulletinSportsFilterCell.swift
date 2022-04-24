//
//  BulletinSportsFilterCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import UIKit

class BulletinSportsFilterCell: UICollectionViewCell {
    @IBOutlet weak var groupIcon: UIImageView!
    @IBOutlet weak var groupTitle: UILabel!
    
    func reloadWith(data: BulletinModels.GroupCellModel) {
        groupTitle.text = data.title
        groupIcon.image = UIImage(named: data.image)
        if data.selected {
            backgroundColor = .green
        } else {
            backgroundColor = .white
        }
    }
}
