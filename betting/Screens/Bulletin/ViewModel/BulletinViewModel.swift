protocol BulletinViewModelProtocol {
    func getGroupsList() -> [String]
    func requestSports()
}
protocol BulletinViewModelDelegate: AnyObject {
    func reloadTable()
}
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
