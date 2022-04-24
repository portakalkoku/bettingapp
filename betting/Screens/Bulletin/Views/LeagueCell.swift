//
//  LeagueCell.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 24.04.2022.
//

import UIKit

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
    var odds: [BulletinModels.Odds] = []
    func reloadWith(
        txt: String,
        odds: [BulletinModels.Odds]
    ) {
        titleLabel.text = txt
        self.odds = odds
        tableView.reloadData()
        layoutIfNeeded()
        layoutSubviews()
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
