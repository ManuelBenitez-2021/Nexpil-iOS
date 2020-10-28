//
//  NotificationsTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/22.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableList: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.initMainView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initMainView() {
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear

        tableList.delegate = self
        tableList.dataSource = self
        tableList.backgroundColor = UIColor.clear
        tableList.isScrollEnabled = false
        tableList.separatorColor = UIColor.clear
        
    }
    
    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return CGFloat(DataUtils.heightTitle)
            
        } else if indexPath.row == 1 {
            return CGFloat(DataUtils.heightSecurity)
            
        } else if indexPath.row == 2 {
            return CGFloat(DataUtils.heightCommunity)
            
        } else if indexPath.row == 3 {
            return CGFloat(DataUtils.heightCommunity)
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
            
            cell.setTitle(str: "Notifications")
            
            return cell
            
        } else if indexPath.row == 1 {
            tableView.register(UINib(nibName: "Notification00TableViewCell", bundle: nil), forCellReuseIdentifier: "Notification00TableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notification00TableViewCell", for: indexPath) as! Notification00TableViewCell
            
            return cell
            
        } else if indexPath.row == 2 {
            tableView.register(UINib(nibName: "Notification01TableViewCell", bundle: nil), forCellReuseIdentifier: "Notification01TableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notification01TableViewCell", for: indexPath) as! Notification01TableViewCell
            
            return cell
            
        } else if indexPath.row == 3 {
            tableView.register(UINib(nibName: "Notification02TableViewCell", bundle: nil), forCellReuseIdentifier: "Notification02TableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Notification02TableViewCell", for: indexPath) as! Notification02TableViewCell
            
            return cell
        }
        
        return UITableViewCell.init()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }

    
}
