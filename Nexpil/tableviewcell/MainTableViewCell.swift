//
//  MainTableViewCell.swift
//  Nexpil
//
//  Created by Admin on 4/7/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var tableInner: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MainTableViewCell {
    func setTableViewDataSourceDelegate
        <D:UITableViewDelegate & UITableViewDataSource>
        (_ dataSourceDelegate: D, forRow: Int)
    {
        tableInner.delegate = dataSourceDelegate
        tableInner.dataSource = dataSourceDelegate
        tableInner.reloadData()
    }
}
