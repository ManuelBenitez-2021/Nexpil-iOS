//
//  SettingsViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/08/22.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SettingsViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    AccountsTableViewCellDelegate,SignoutsTableViewCellDelegate {

    @IBOutlet weak var tableList: UITableView!
    
    let items = 8
    
    let arrayAccount : [String] = [
        "Email Address",
        "Password",
        "Language"
        ]
    let arraySupport : [String] = [
        "Help Center",
        "Invite your Friends",
        "Rate nexpil",
        "Send us Feedback"
    ]
    let arraylegal : [String] = [
        "Terms and Conditions",
        "Private Policy",
        "Disclaimer"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initMainView() {
        tableList.delegate = self
        tableList.dataSource = self
    }

    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return CGFloat(DataUtils.heightTitle + arrayAccount.count * DataUtils.heightCommunity)
        case 1:
            return CGFloat(DataUtils.heightTitle + DataUtils.heightSecurity)
        case 2:
            return CGFloat(DataUtils.heightTitle + DataUtils.heightSecurity + 2 * DataUtils.heightCommunity)
        case 3:
            return CGFloat(DataUtils.heightTitle + arraySupport.count * DataUtils.heightCommunity)
        case 4:
            return CGFloat(DataUtils.heightTitle + arraylegal.count * DataUtils.heightCommunity)
        case 5:
            return CGFloat(DataUtils.heightCommunity)
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            tableView.register(UINib(nibName: "AccountsTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountsTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsTableViewCell", for: indexPath) as! AccountsTableViewCell
            
            cell.delegate = self
            cell.arrayList = arrayAccount
            return cell
            
        case 1:
            tableView.register(UINib(nibName: "SecuritiesTableViewCell", bundle: nil), forCellReuseIdentifier: "SecuritiesTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecuritiesTableViewCell", for: indexPath) as! SecuritiesTableViewCell
            
            return cell
            
        case 2:
            tableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
            
            return cell
            
        case 3:
            tableView.register(UINib(nibName: "SupportsTableViewCell", bundle: nil), forCellReuseIdentifier: "SupportsTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SupportsTableViewCell", for: indexPath) as! SupportsTableViewCell
            
            cell.arrayList = arraySupport
            return cell
            
        case 4:
            tableView.register(UINib(nibName: "LegalsTableViewCell", bundle: nil), forCellReuseIdentifier: "LegalsTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "LegalsTableViewCell", for: indexPath) as! LegalsTableViewCell
            
            cell.arrayList = arraylegal
            return cell
            
        case 5:
            tableView.register(UINib(nibName: "SignoutsTableViewCell", bundle: nil), forCellReuseIdentifier: "SignoutsTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignoutsTableViewCell", for: indexPath) as! SignoutsTableViewCell
            cell.delegate = self
            return cell
            
        default:
            break
        }
        
        return UITableViewCell.init()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        //        let dicList = arrayList![indexPath.row] as! NSDictionary
        //        self.delegate?.didTapButtonAtHomeViewController(dic: dicList, index: indexPath.row)
        
    }
    
    // MARK: - AccountsTableViewCell delegate
    func didTapButtonAccountsTableViewCell(index: NSInteger) {
        // index: 1;email , 2; password, 3; language
        if index > 0 {
            print(">>>> index:%ld", index)
        }
    }
    
    func didTapButtonsignoutsTableViewCell(index: NSInteger) {
        if index == 0
        {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingScreenViewController") as! LandingScreenViewController
            //viewController.tabBar.roundCorners([.topLeft, .topRight], radius: 10)
            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //appDelegate.window?.rootViewController = viewController
            //let navController = UINavigationController(rootViewController: viewController)
            //self.navigationController?.pushViewController(viewController, animated: false)
            present(viewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
