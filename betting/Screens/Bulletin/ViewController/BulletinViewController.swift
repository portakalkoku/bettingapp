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
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "LeagueCell", bundle: nil), forCellReuseIdentifier: "LeagueCell")
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!{
        didSet {
            activityIndicator.isHidden = true
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
        viewModel.requestGroups()
    }

}

extension BulletinViewController: BulletinViewModelDelegate {
    func reloadCollectionView() {
        filterCollectionView.reloadData()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showErrorMessage() {
        // TODO: (cagri) - show error message
    }
}

extension BulletinViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getGroupsList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BulletinSportsFilterCell", for: indexPath) as! BulletinSportsFilterCell
        let group = viewModel.getGroupsList()[indexPath.row]
        cell.reloadWith(data: group)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectGroup(group: viewModel.getGroupsList()[indexPath.row].title)
    }
}

extension BulletinViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getLeagueList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeagueCell") as! LeagueCell
        let league = viewModel.getLeagueList()[indexPath.row]
        cell.reloadWith(sport: league, events: viewModel.getOddsOfSport(sportKey: league.key))
        cell.delegate = self
        return cell
    }

}

extension BulletinViewController: LeagueCellDelegate {
    func didTapSport(key: String) {
        viewModel.requestOdds(key: key)
    }
}
