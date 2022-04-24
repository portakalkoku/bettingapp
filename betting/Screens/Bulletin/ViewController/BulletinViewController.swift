//
//  BulletinViewController.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import UIKit

class BulletinViewController: UIViewController {

    let viewModel: BulletinViewModelProtocol
    @IBOutlet weak var filterCollectionView: UICollectionView! {
        didSet {
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
            filterCollectionView.register(UINib(nibName: "BulletinSportsFilterCell", bundle: nil), forCellWithReuseIdentifier: "BulletinSportsFilterCell")
        }
    }
    init(
        viewModel: BulletinViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestSports()
    }

}

extension BulletinViewController: BulletinViewModelDelegate {
    func reloadTable() {
        filterCollectionView.reloadData()
    }
}

extension BulletinViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getGroupsList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BulletinSportsFilterCell", for: indexPath) as! BulletinSportsFilterCell
        let groupName = viewModel.getGroupsList()[indexPath.row]
        cell.reloadWith(text: groupName)
        return cell
    }
}
