//
//  BulletinViewModel.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

protocol BulletinViewModelProtocol {
    func getGroupsList() -> [String]
    func requestSports()
}

protocol BulletinViewModelDelegate: AnyObject {
    func reloadTable()
}

class BulletinViewModel: BulletinViewModelProtocol {
    weak var delegate: BulletinViewModelDelegate?
    private var sports: [BulletinModels.Sport] = []
    private var groups: [String] = []
    
    let api: API
    init(
        api: API
    ) {
        self.api = api
    }
    
    func requestSports() {
        api.request(type: RequestType.sports) { result in
            switch result {
            case let .success(data):
                let jsonDecoder = JSONDecoder()
                guard let data = try? jsonDecoder.decode([BulletinModels.Sport].self, from: data) else {
                    //wrong
                    return
                }
                self.groups = Array(Set(data.map({$0.group})))
                self.sports = data
                self.delegate?.reloadTable()
            case let .failure(_):
                break
            }
        }
    }
    
    func getGroupsList() -> [String] {
        groups
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
    
