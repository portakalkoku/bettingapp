//
//  BulletinViewModel.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import Foundation
import RxSwift

protocol BulletinViewModelProtocol {
    func getGroupsList() -> [BulletinModels.GroupCellModel]
    func getLeagueList() -> [BulletinModels.Sport]
    func getOddsOfSport(sportKey: String) -> [BulletinModels.EventCellModel]
    func requestGroups()
    func requestOdds(key: String)
    func selectGroup(group: String)
    func addOrRemoveEventFromCart(event: CartModels.Event)
    func searchBy(_ text: String)
    func didTapRouteToCheckout()
    func setup()
}

protocol BulletinViewModelDelegate: AnyObject {
    func reloadCollectionView()
    func reloadTableView()
    func showErrorMessage()
    func showLoading()
    func hideLoading()
    func reloadCartView(multiplier: Double)
    func routeToCheckout(cart: CartProtocol)
}

struct BulletinViewModelDataStore{
    var sports: [BulletinModels.Sport]
    var groups: [BulletinModels.GroupCellModel]
    var filteredSports: [BulletinModels.Sport]
    var selectedGroup: String?
    var searchText: String
    var odds: [BulletinModels.Odds]
}

// MARK: - BulletinViewModelProtocol
class BulletinViewModel: BulletinViewModelProtocol  {
    var firebaseHelper: FirebaseHelperProtocol?
    weak var delegate: BulletinViewModelDelegate?
    private var disposeBag = DisposeBag()
    var dataStore: BulletinViewModelDataStore = .init(
        sports: [],
        groups: [],
        filteredSports: [],
        selectedGroup: nil,
        searchText: "",
        odds: []
    )
    
    // MARK: - init
    let api: APIProtocol
    let cart: CartProtocol
    init(
        api: APIProtocol,
        cart: CartProtocol
    ) {
        self.api = api
        self.cart = cart
        setupRx()
    }
    
    func requestGroups() {
        delegate?.showLoading()
        api.request(type: RequestType.sports) { result in
            self.delegate?.hideLoading()
            switch result {
            case let .success(data):
                let jsonDecoder = JSONDecoder()
                guard let data = try? jsonDecoder.decode([BulletinModels.Sport].self, from: data) else {
                    self.delegate?.showErrorMessage()
                    return
                }
                
                self.dataStore.sports = data
                self.dataStore.groups = self.processGroups(stringSet: Set(data.map({$0.group})))
                self.delegate?.reloadCollectionView()
            case .failure(_):
                self.delegate?.showErrorMessage()
            }
        }
    }
    
    func requestOdds(key: String) {
        delegate?.showLoading()
        api.request(type: RequestType.odds(key: key)) { result in
            self.delegate?.hideLoading()
            switch result {
            case let .success(data):
                let jsonDecoder = JSONDecoder()
                guard let data = try? jsonDecoder.decode([BulletinModels.Odds].self, from: data), data.count > 0 else {
                    self.delegate?.showErrorMessage()
                    return
                }
                if !self.dataStore.odds.contains(where: {$0.sport_key == data[0].sport_key}) {
                    self.dataStore.odds.append(contentsOf: data)
                    self.delegate?.reloadTableView()
                }
            case .failure(_):
                self.delegate?.showErrorMessage()
            }
        }
    }
    
    func getGroupsList() -> [BulletinModels.GroupCellModel] {
        dataStore.groups
    }
    
    func getLeagueList() -> [BulletinModels.Sport] {
        dataStore.filteredSports
    }
    
    func getOddsOfSport(sportKey: String) -> [BulletinModels.EventCellModel] {
        firebaseHelper?.sendEvent("league_tap", parameters: ["sportKey": sportKey])
        return getOutcomes(sportKey: sportKey)
    }
    
    func selectGroup(group: String) {
        dataStore.selectedGroup = group
        dataStore.groups = processGroups(stringSet: Set(dataStore.sports.map({$0.group})))
        dataStore.filteredSports = filterLeagues()
        delegate?.reloadCollectionView()
        delegate?.reloadTableView()
    }
    
    func addOrRemoveEventFromCart(event: CartModels.Event) {
        cart.addOrRemoveEvent(event)
        delegate?.reloadTableView()
    }
    
    func searchBy(_ text: String) {
        dataStore.searchText = text
        delegate?.reloadTableView()
    }
    
    func didTapRouteToCheckout() {
        disposeBag = DisposeBag()
        delegate?.routeToCheckout(cart: cart)
    }
    
    func setup() {
        setupRx()
    }
}

extension BulletinViewModel {
    private func setupRx() {
        cart.events.asObservable().subscribe(onNext: { [self] value in
            delegate?.reloadCartView(multiplier: cart.getMultiplier())
        }).disposed(by: disposeBag)
    }
}


extension BulletinViewModel {
    private func processGroups(stringSet: Set<String>) -> [BulletinModels.GroupCellModel] {
        var groups: [BulletinModels.GroupCellModel]  = []
        if let selectedGroup = dataStore.selectedGroup {
            groups = stringSet.map { key in
                return BulletinModels.GroupCellModel.init(
                    image: SportType.init(rawValue: key)?.getSportIcon() ?? "medal",
                    title: key,
                    selected: key == selectedGroup)
            }.sorted(by: {$0.title > $1.title})
        } else {
            groups = stringSet.map { key in
                return BulletinModels.GroupCellModel.init(
                    image: SportType.init(rawValue: key)?.getSportIcon() ?? "medal",
                    title: key,
                    selected: false
                )
            }.sorted(by: {$0.title > $1.title})
            
            let firstElement = groups[0]
            groups.remove(at: 0)
            groups.insert(.init(image: firstElement.image, title: firstElement.title, selected: true), at: 0)
            dataStore.selectedGroup = firstElement.title
            dataStore.filteredSports = filterLeagues()
            delegate?.reloadTableView()
        }
        return groups
    }
    
    private func filterLeagues(_ txt: String = "") -> [BulletinModels.Sport] {
        if txt.isEmpty {
            return dataStore.sports.filter({$0.group == dataStore.selectedGroup})
            
        } else {
            return dataStore.sports.filter({$0.group == dataStore.selectedGroup && $0.title.lowercased().contains(txt.lowercased())})
        }
    }
    
    private func getOutcomes(
        sportKey: String
    ) -> [BulletinModels.EventCellModel] {
        
        let filteredOdds = dataStore.odds.filter({$0.sport_key == sportKey})
        let mapped: [BulletinModels.EventCellModel?] = filteredOdds.map { odd in
            if odd.bookmakers.count > 0, let outcomes = odd.bookmakers[0].markets.first(where: {$0.key == "h2h"})?.outcomes {
                var odds: [BulletinModels.OddCellModel] = []
                outcomes.forEach { outcome in
                    if outcome.name == odd.home_team {
                        odds.append(.init(id: odd.id, price: outcome.price, selected: cart.checkIfOddExistInCart(odd.id, type: .home), type: .home))
                    } else if outcome.name == odd.away_team {
                        odds.append(.init(id: odd.id, price: outcome.price, selected: cart.checkIfOddExistInCart(odd.id, type: .away), type: .away))
                    } else {
                        odds.append(.init(id: odd.id, price: outcome.price, selected: cart.checkIfOddExistInCart(odd.id, type: .draw), type: .draw))
                    }
                }
                
                odds = odds.sorted(by: {$0.type.rawValue < $1.type.rawValue})
                let matchName = "\(odd.home_team)-\(odd.away_team)"
                if !dataStore.searchText.isEmpty {
                    if matchName.contains(dataStore.searchText) {
                        return .init(
                            matchName: matchName,
                            odds: odds
                        )
                    }
                    return nil
                }
                return .init(
                    matchName: matchName,
                    odds: odds
                )
            }
            return nil
        }
        
        guard let returnedList: [BulletinModels.EventCellModel] = mapped.compactMap({$0}) as? [BulletinModels.EventCellModel] else {
            return []
        }
        return returnedList
    }
}


