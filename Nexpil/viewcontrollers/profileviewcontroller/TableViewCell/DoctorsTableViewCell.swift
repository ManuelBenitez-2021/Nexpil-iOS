//
//  DoctorsTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/21.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class DoctorsTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableList: UITableView!
    var arrayList = [NSDictionary]()
    
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
        
        tableList.delegate = self
        tableList.dataSource = self
        tableList.backgroundColor = UIColor.clear
        tableList.isScrollEnabled = false
        tableList.separatorColor = UIColor.clear

    }
    
    func setInfo(dic: NSMutableDictionary) {
        
    }
    
    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count + 2
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayList.count == 0 {
            if indexPath.row == 0 {
                return CGFloat(DataUtils.heightTitle)
                
            } else {
                return CGFloat(DataUtils.heightAdd)
            }
            
        } else {
            if indexPath.row == 0 {
                return CGFloat(DataUtils.heightTitle)
                
            } else if indexPath.row == arrayList.count + 1 {
                return CGFloat(DataUtils.heightAdd)
                
            } else {
                return CGFloat(DataUtils.heightDoctor)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayList.count == 0 {
            if indexPath.row == 0 {
                tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
                
                cell.setTitle(str: "Doctors")
                
                return cell
                
            } else {
                tableView.register(UINib(nibName: "AddTableViewCell01", bundle: nil), forCellReuseIdentifier: "AddTableViewCell01")
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell01", for: indexPath) as! AddTableViewCell01
                
                cell.setTitle(str: "Add Doctor")
                
                return cell
                
            }

        } else {
            if indexPath.row == 0 {
                tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: "TitleTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as! TitleTableViewCell
                
                cell.setTitle(str: "Doctors")
                
                return cell
                
            } else if indexPath.row == arrayList.count + 1 {
                tableView.register(UINib(nibName: "AddTableViewCell01", bundle: nil), forCellReuseIdentifier: "AddTableViewCell01")
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell01", for: indexPath) as! AddTableViewCell01
                
                cell.setTitle(str: "Add Doctor")
                
                return cell
                
            } else {
                tableView.register(UINib(nibName: "DoctorTableViewCell", bundle: nil), forCellReuseIdentifier: "DoctorTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorTableViewCell", for: indexPath) as! DoctorTableViewCell

                cell.setInfo(dic: arrayList[indexPath.row - 1])
                
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    

    
}
