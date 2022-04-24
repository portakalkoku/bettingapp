//
//  LeagueCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import UIKit

protocol LeagueCellDelegate: AnyObject {
    func didTapSport(key: String)
}

class LeagueCell: UITableViewCell {
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
    
    var odds: [BulletinModels.Odds] = []
    private var sport: BulletinModels.Sport?
    
    func reloadWith(
        sport: BulletinModels.Sport,
        odds: [BulletinModels.Odds]
    ) {
        titleLabel.text = sport.title
        self.odds = odds
        if odds.count > 0 {
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
        tableView.reloadData()
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        tableViewHeightConstraint.constant = tableView.calculateTableHeight(rowCount: odds.count)
    }
}

extension LeagueCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return odds.count
    }
}
