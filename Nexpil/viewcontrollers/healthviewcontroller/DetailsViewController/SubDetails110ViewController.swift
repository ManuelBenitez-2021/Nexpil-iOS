//
//  SubDetails110ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SubDetails110ViewControllerDelegate: class {
    func didTapButtonAddWithSubDetails110ViewController()
}

class SubDetails110ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate:SubDetails110ViewControllerDelegate?

    @IBOutlet weak var tableList: UITableView!
    
    var arrayList = NSArray()
    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchLipidPanel(index: "HDL")
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
    
    // MARK - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 790
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if arrayList.count == 0 {
            return 1
        } else {
            return arrayList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            tableView.register(UINib(nibName: "AddTableViewCell", bundle: nil), forCellReuseIdentifier: "AddTableViewCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddTableViewCell", for: indexPath) as! AddTableViewCell
            cell.selectionStyle = .default
            cell.setInfo(index: 7)
            
            return cell
            
        } else {
            if arrayList.count > 0 {
                let dicList = arrayList[indexPath.row - 1] as! NSDictionary
            
                tableView.register(UINib(nibName: "LipidPanelHDLTableViewCell", bundle: nil), forCellReuseIdentifier: "LipidPanelHDLTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "LipidPanelHDLTableViewCell", for: indexPath) as! LipidPanelHDLTableViewCell
                cell.selectionStyle = .none
                cell.setInfo(dic: dicList)
            
                return cell
            } else {
                return UITableViewCell.init()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
        
        if indexPath.row == 0 {
            self.delegate?.didTapButtonAddWithSubDetails110ViewController()
            
        } else {
            //            let videoDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as? VideoDetailViewController
            //            videoDetailViewController?.dicVideo = arrayVideos[indexPath.row] as! NSDictionary
            //            self.navigationController?.pushViewController(videoDetailViewController!, animated: true)
        }
        
    }

    // insert
    func insertLipidPanel(date: Date, value: NSInteger, index: String) {
        SVProgressHUD.show()
        let retult = manager.insertLipidPanel(date: date, value: value, index: index)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchLipidPanel(index: index)
        } else {
            
        }
    }
    
    // fetch
    func fetchLipidPanel(index: String) {
        SVProgressHUD.show()
        
        let array = manager.fetchLipidPanelGetAllYearData(index: index)
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            tableList.reloadData()
        }
    }
    
    func loadAlertController(message: String) {
        let alert = UIAlertController(title: message,
                                      message: nil,
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
