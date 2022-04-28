//
//  BulletinViewController.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import UIKit

class BulletinViewController: UIViewController {
    
    // MARK: - IBOutlets
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
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "LeagueCell", bundle: nil), forCellReuseIdentifier: "LeagueCell")
        }
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!{
        didSet {
            activityIndicator.isHidden = true
        }
    }
    @IBOutlet weak var cartView: CartView! {
        didSet {
            cartView.layer.cornerRadius = 5.0
            cartView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            cartView.delegate = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.searchTextField.placeholder = "Search by event or league"
        }
    }
    
    // MARK: - Init
    let viewModel: BulletinViewModelProtocol
    let router: BulletinRouting
    
    init(
        viewModel: BulletinViewModelProtocol,
        router: BulletinRouting
    ) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestGroups()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.setup()
        tableView.reloadData()
    }
}


// MARK: - BulletinViewModelDelegate
extension BulletinViewController: BulletinViewModelDelegate {
    func reloadCartView(multiplier: Double) {
        cartView.reloadViewWith(multiplier)
    }
    
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
    
    func routeToCheckout(cart: CartProtocol) {
        router.routeToCheckout(with: cart)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
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

// MARK: - UITableViewDelegate, UITableViewDataSource
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

// MARK: - LeagueCellDelegate
extension BulletinViewController: LeagueCellDelegate {
    func didTapOdd(_ odd: CartModels.Event) {
        viewModel.addOrRemoveEventFromCart(event: odd)
    }
    
    func didTapSport(key: String) {
        viewModel.requestOdds(key: key)
    }
}

// MARK: - UISearchBarDelegate
extension BulletinViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchBy(searchText)
    }
}

// MARK: - CartViewDelegate
extension BulletinViewController: CartViewDelegate {
    func didTapCheckout() {
        viewModel.didTapRouteToCheckout()
    }
}
