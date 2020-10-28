//
//  SubDetails000ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SubDetails000ViewControllerDelegate: class {
    func didTapButtonAddWithSubDetails000ViewController()
    func didTapButtonUpdateWithSubDetails000ViewController(index: NSInteger, sendDic: NSDictionary)
}

class SubDetails000ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BloodGlucoseDayTableViewCellDelegate {

    weak var delegate:SubDetails000ViewControllerDelegate?
    @IBOutlet weak var tableList: UITableView!
    var arrayList = NSMutableArray()
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
        
        self.fetchBloodGlucose()
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
            return 550
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
            cell.selectionStyle = .none
            cell.setInfo(index: 0)
            
            return cell
            
        } else {
            if arrayList.count > 0 {
                let dicList = arrayList[indexPath.row - 1] as! NSDictionary
                tableView.register(UINib(nibName: "BloodGlucoseDayTableViewCell", bundle: nil), forCellReuseIdentifier: "BloodGlucoseDayTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "BloodGlucoseDayTableViewCell", for: indexPath) as! BloodGlucoseDayTableViewCell
                cell.selectionStyle = .none
                cell.setInfo(dic: dicList)
                cell.delegate = self
            
                return cell
            } else {
                return UITableViewCell.init()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
        
        if indexPath.row == 0 {
            self.delegate?.didTapButtonAddWithSubDetails000ViewController()
            
        }
        
    }
    
    // MARK - BloodGlucoseTableViewCell delegate
    func didTapButtonBloodGlucoseDayTableViewCell(index: NSInteger, sendDic: NSDictionary) {
        self.delegate?.didTapButtonUpdateWithSubDetails000ViewController(index: index, sendDic: sendDic)
    }

    // MARK - insert
    func insertBloodGlucose(date: Date, whenIndex: String, value: NSInteger) {
        SVProgressHUD.show()
        let retult = manager.insertBloodGlucose(date: date, whenIndex: whenIndex, value: value)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchBloodGlucose()
        } else {
            
        }
        
    }
    
    func fetchBloodGlucose() {
        SVProgressHUD.show()
        
        let array = manager.fetchBloodGlucoseGetAllDaysData()
        
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            tableList.reloadData()
        }
        
        tableList.setContentOffset(.zero, animated: true)

    }
    
}
