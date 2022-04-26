//
//  EventCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(.init(nibName: "OddCell", bundle: nil), forCellWithReuseIdentifier: "OddCell")
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    func reloadWith(data: String) {
        eventNameLabel.text = data
        collectionView.reloadData()
    }
}

extension EventCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        odds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OddCell", for: indexPath) as! OddCell
        cell.reloadWith(odd: odds[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3
        return .init(width: width, height: width)
    }
}
