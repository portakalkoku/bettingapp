//
//  LeagueCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import UIKit

protocol LeagueCellDelegate: AnyObject {
    func didTapSport(key: String)
    func didTapOdd(_ odd: CartModels.Event)
}

class LeagueCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(.init(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    weak var delegate: LeagueCellDelegate?
    
    var events: [BulletinModels.EventCellModel] = []
    private var sport: BulletinModels.Sport?
    
    func reloadWith(
        sport: BulletinModels.Sport,
        events: [BulletinModels.EventCellModel]
    ) {
        self.sport = sport
        titleLabel.text = sport.title
        self.events = events
        tableView.reloadData()
        layoutIfNeeded()
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        tableViewHeightConstraint.constant = tableView.calculateTableHeight(rowCount: events.count)
    }
    @IBAction func didTapSport(_ sender: Any) {
        guard let sport = sport else { return }
        delegate?.didTapSport(key: sport.key)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LeagueCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        cell.reloadWith(data: events[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
}

// MARK: - EventCellDelegate
extension LeagueCell: EventCellDelegate {
    func didTapOdd(_ odd: CartModels.Event) {
        delegate?.didTapOdd(odd)
    }
}
