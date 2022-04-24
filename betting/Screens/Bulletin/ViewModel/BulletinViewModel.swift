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
