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
    func getOddsOfSport(sportKey: String) -> [BulletinModels.Odds]
    func requestGroups()
    func requestOdds(key: String)
    func selectGroup(group: String)
}

protocol BulletinViewModelDelegate: AnyObject {
    func reloadCollectionView()
    func reloadTableView()
    func showErrorMessage()
    func showLoading()
    func hideLoading()
}

class BulletinViewModel: BulletinViewModelProtocol {
    weak var delegate: BulletinViewModelDelegate?
    private var sports: [BulletinModels.Sport] = []
    private var groups: [BulletinModels.GroupCellModel] = []
    private var filteredSports: [BulletinModels.Sport] = []
    private var selectedGroup: String?
    private var odds: [BulletinModels.Odds] = []
    
    let api: API
    init(
        api: API
    ) {
        self.api = api
    }
    
    func requestGroups() {
        api.request(type: RequestType.sports) { result in
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
        api.request(type: RequestType.odds(key: key)) { result in
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
    
    func getOddsOfSport(sportKey: String) -> [BulletinModels.Odds] {
        return odds.filter({$0.sport_key == sportKey})
    }
    
    func selectGroup(group: String) {
        selectedGroup = group
        groups = processGroups(stringSet: Set(sports.map({$0.group})))
        filteredSports = filterLeagues()
        delegate?.reloadCollectionView()
        delegate?.reloadTableView()
    }
}

extension BulletinViewModel {
    private func getSportIcon(sport: SportType?) -> String {
        switch sport {
        case .soccer:
            return "football"
        case .basketball:
            return "basketball"
        case .baseball:
            return "baseball"
        case .americanFootball:
            return "american-football"
        case .rugby:
            return "rugby"
        case .golf:
            return "golf"
        case .martialArts:
            return "martial-arts"
        case .aussieFootball:
            return "aussie-rules"
        case .iceHockey:
            return "ice-hockey"
        case .cricket:
            return "cricket"
        case .none:
            return "medal"
        }
    }
    
    private func processGroups(stringSet: Set<String>) -> [BulletinModels.GroupCellModel] {
        var groups: [BulletinModels.GroupCellModel]  = []
        if let selectedGroup = selectedGroup {
            groups = stringSet.map { key in
                return BulletinModels.GroupCellModel.init(
                    image: getSportIcon(sport: .init(rawValue: key)),
                    title: key,
                    selected: key == selectedGroup)
            }.sorted(by: {$0.title > $1.title})
        } else {
            groups = stringSet.map { key in
                return BulletinModels.GroupCellModel.init(
                    image: getSportIcon(sport: .init(rawValue: key)),
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
    
    private func filterLeagues() -> [BulletinModels.Sport] {
        return sports.filter({$0.group == selectedGroup})
    }

}

