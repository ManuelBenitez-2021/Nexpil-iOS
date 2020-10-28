//
//  SignoutsTableViewCell.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/22.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol SignoutsTableViewCellDelegate: class {
    func didTapButtonsignoutsTableViewCell(index: NSInteger)
}

class SignoutsTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableList: UITableView!
    var delegate:SignoutsTableViewCellDelegate?
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
        tableList.separatorColor = UIColor.clear
        tableList.isScrollEnabled = false
    }
    
    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(DataUtils.heightMedication)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "SignoutTableViewCell", bundle: nil), forCellReuseIdentifier: "SignoutTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "SignoutTableViewCell", for: indexPath) as! SignoutTableViewCell
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        self.delegate?.didTapButtonsignoutsTableViewCell(index: indexPath.row)
    }

}
