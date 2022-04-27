//
//  UITableView+Extensions.swift
//  betting
//
//  Created by Çağrı Portakalkökü on 25.04.2022.
//

import UIKit
extension UITableView {
    func calculateTableHeight(rowCount: Int) -> CGFloat {
        guard frame.width > 0 else { return 0.0 }
        layoutIfNeeded()
        var tableViewHeight: CGFloat = 0
        
        for index in 0 ..< rowCount {
            tableViewHeight += rectForRow(at: IndexPath(row: index, section: 0)).height
        }
        
        tableViewHeight += rectForHeader(inSection: 0).height
        return tableViewHeight
    }
}
