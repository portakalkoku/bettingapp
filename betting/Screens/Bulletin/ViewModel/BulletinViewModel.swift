//
//  BulletinViewModel.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import Foundation

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
}

protocol BulletinViewModelDelegate: AnyObject {
    func reloadCollectionView()
    func reloadTableView()
    func showErrorMessage()
    func showLoading()
    func hideLoading()
    func reloadCartView(multiplier: Double)
    func routeToCheckout(cart: Cart)
}

class BulletinViewModel {

    weak var delegate: BulletinViewModelDelegate?
    private var sports: [BulletinModels.Sport] = []
    private var groups: [BulletinModels.GroupCellModel] = []
    private var filteredSports: [BulletinModels.Sport] = []
    private var selectedGroup: String?
    private var searchText: String = ""
    private var odds: [BulletinModels.Odds] = []
    
    let api: API
    let cart: Cart
    init(
        api: API,
        cart: Cart
    ) {
        self.api = api
        self.cart = cart
        setupRx()
    }
}

extension BulletinViewModel: BulletinViewModelProtocol {
    
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
                
                self.sports = data
                self.groups = self.processGroups(stringSet: Set(data.map({$0.group})))
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
                guard let data = try? jsonDecoder.decode([BulletinModels.Odds].self, from: data) else {
                    self.delegate?.showErrorMessage()
                    return
                }
                if !self.odds.contains(where: {$0.sport_key == data[0].sport_key}) {
                    self.odds.append(contentsOf: data)
                    self.delegate?.reloadTableView()
                }
            case .failure(_):
                self.delegate?.showErrorMessage()
            }
        }
    }

    func getGroupsList() -> [BulletinModels.GroupCellModel] {
        groups
    }
    
    func getLeagueList() -> [BulletinModels.Sport] {
        filteredSports
    }
    
    func getOddsOfSport(sportKey: String) -> [BulletinModels.EventCellModel] {
        getOutcomes(sportKey: sportKey)
    }
  
    func selectGroup(group: String) {
        selectedGroup = group
        groups = processGroups(stringSet: Set(sports.map({$0.group})))
        filteredSports = filterLeagues()
        delegate?.reloadCollectionView()
        delegate?.reloadTableView()
    }
    
    func addOrRemoveEventFromCart(event: CartModels.Event) {
        cart.addOrRemoveEvent(event)
        delegate?.reloadTableView()
    }
    
    func searchBy(_ text: String) {
        searchText = text
        delegate?.reloadTableView()
    }
    
    func didTapRouteToCheckout() {
        delegate?.routeToCheckout(cart: cart)
    }
}

extension BulletinViewModel {
    private func setupRx() {
        cart.events.asObservable().subscribe(onNext: { [self] value in
           delegate?.reloadCartView(multiplier: cart.getMultiplier())
        })
    }
}


extension BulletinViewModel {
    private func processGroups(stringSet: Set<String>) -> [BulletinModels.GroupCellModel] {
        var groups: [BulletinModels.GroupCellModel]  = []
        if let selectedGroup = selectedGroup {
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
            selectedGroup = firstElement.title
            filteredSports = filterLeagues()
            delegate?.reloadTableView()
        }
        return groups
    }
    
    private func filterLeagues(_ txt: String = "") -> [BulletinModels.Sport] {
        if txt.isEmpty {
            return sports.filter({$0.group == selectedGroup})

        } else {
            return sports.filter({$0.group == selectedGroup && $0.title.lowercased().contains(txt.lowercased())})
        }
    }
    
    private func getOutcomes(
        sportKey: String
    ) -> [BulletinModels.EventCellModel] {
        
        let filteredOdds = odds.filter({$0.sport_key == sportKey})
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
                if !searchText.isEmpty {
                    if matchName.contains(searchText) {
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


