//
//  SubDetails010ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SubDetails010ViewControllerDelegate: class {
    func didTapButtonAddWithSubDetails010ViewController()
}

class SubDetails010ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate:SubDetails010ViewControllerDelegate?
    
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
        
        self.fetchBloodPressure()
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
            return 520
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
            cell.setInfo(index: 1)
            
            return cell
            
        } else {
            if arrayList.count > 0 {
                let dicList = arrayList[indexPath.row - 1] as! NSDictionary
            
                tableView.register(UINib(nibName: "BloodPressureDayTableViewCell", bundle: nil), forCellReuseIdentifier: "BloodPressureDayTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "BloodPressureDayTableViewCell", for: indexPath) as! BloodPressureDayTableViewCell
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
            self.delegate?.didTapButtonAddWithSubDetails010ViewController()
            
        } else {
            //            let videoDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as? VideoDetailViewController
            //            videoDetailViewController?.dicVideo = arrayVideos[indexPath.row] as! NSDictionary
            //            self.navigationController?.pushViewController(videoDetailViewController!, animated: true)
        }
        
    }

    // MARK - insert
    func insertBloodPressurel(date: Date, time: String, timeIndex: String, value1: NSInteger, value2: NSInteger) {
        SVProgressHUD.show()
        let retult = manager.insertBloodPressure(date: date, time: time, timeIndex: timeIndex, value1: value1, value2: value2)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchBloodPressure()
        } else {
            
        }
        
    }
    
    func fetchBloodPressure() {
        SVProgressHUD.show()
        
        let array = manager.fetchBloodPressureGetAllDaysData()
        
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            tableList.reloadData()
        }
        
        tableList.setContentOffset(.zero, animated: true)
        
    }
}
