//
//  AtHomeViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol AtHomeViewControllerDelegate: class {
    func didTapButtonAtHomeViewController(dic: NSDictionary, index: NSInteger)
    func didTapButtonAtHomeViewControllerRefresh()
}

class AtHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate:AtHomeViewControllerDelegate?
    
    @IBOutlet weak var tableList: UITableView!
    
    let tabTitle = "At Home"
    
    var arrayList: NSMutableArray?
    var manager = DataManager()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getSelfData()
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

    // init MainView
    func initMainView() {
        // table
        tableList.delegate = self
        tableList.dataSource = self
        tableList.separatorColor = UIColor.clear
        
        tableList.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        
        tableList.addSubview(refreshControl)

    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.delegate?.didTapButtonAtHomeViewControllerRefresh()
        self.getSelfData()
        refreshControl.endRefreshing()
    }
    
    func getSelfData() {
        // array
        arrayList = NSMutableArray.init()
        
        let bloodGlucose = self.getBloodGlocose()
        let bloodPressure = self.getBloodPressure()
        let oxygenLevel = self.getOxygenlevel()
        let mood = self.getMood()
        let steps = self.getSteps()
        let weight = self.getWeight()
        
        let dic0 = NSDictionary.init(objects: ["Blood Glucose", "Blood Glucose", bloodGlucose, "mg/dl", "icon_blood_glucose", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic1 = NSDictionary.init(objects: ["Blood Pressure", "Blood Pressure", bloodPressure, "", "icon_blood_pressure", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic2 = NSDictionary.init(objects: ["Oxygen Level", "Oxygen Level", oxygenLevel, "%", "", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic3 = NSDictionary.init(objects: ["Mood", "Mood", mood, "", "", "#333333"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic4 = NSDictionary.init(objects: ["Steps", "Steps", steps, "", "", "#8495ED"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        let dic5 = NSDictionary.init(objects: ["Weight", "Weight", weight, "lbs", "", "#877CEC"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString, "icon" as NSString, "unit_color" as NSString])
        
        arrayList = NSMutableArray.init(array: [dic0, dic1, dic2, dic3, dic4, dic5])
        arrayCondition = arrayList as! [NSDictionary]
        DispatchQueue.main.async {
            self.tableList.reloadData()
        }

    }
    
    func getBloodGlocose() -> String {
        let array = manager.fetchBloodGlucoseGetAllDaysData()
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! BloodGlucose
            let value = data.value
            
            return String(format: "%ld", value)
            
        } else {
            return ""
        }
    }
    
    func getBloodPressure() -> String {
        let array = manager.fetchBloodPressureGetAllDaysData()
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! BloodPressure
            let value1 = data.value1
            let value2 = data.value2
            
            return String(format: "%ld/%ld", value1, value2)
        } else {
            return ""
        }
    }
    
    func getOxygenlevel() -> String {
        let array = manager.fetchOxygenLevelGetAllDaysData()
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! OxygenLevel
            let value = data.value
            
            return String(format: "%ld", value)
        } else {
            return ""
        }
    }
    
    func getMood() -> String {
        let array = manager.fetchMood()
        if array.count > 0 {
            let data = array.firstObject as! Mood
            let value = Int(data.feeling)
            
            let arrayFeeling = [
                ["index": "0", "imageName": "feel_0", "title": "Very Sad"],
                ["index": "1", "imageName": "feel_1", "title": "Sad"],
                ["index": "2", "imageName": "feel_2", "title": "Neutral"],
                ["index": "3", "imageName": "feel_3", "title": "Happy"],
                ["index": "4", "imageName": "feel_4", "title": "Very Happy"],
                ]
            
            return String(format: "%@", ((arrayFeeling[value] as NSDictionary).value(forKey: "title") as! String))
        } else {
            return ""
        }
    }
    
    func getSteps() -> String {
        let array = manager.fetchStepsGetAllDaysData()
        if array.count > 0 {
            let dic = array[0] as! NSDictionary
            if dic.value(forKey: "data") != nil {
                let arrayDic = dic.value(forKey: "data") as! NSArray
                if arrayDic.count > 0 {
                    let data = arrayDic[0] as! Steps
                    let value = data.value
                    return String(format: "%0.0f", value)

                } else {
                    return ""
                }
                
            } else {
                return ""
            }
            
        } else {
            return ""
        }
        
    }
    
    func getWeight() -> String {
        if UserDefaults.standard.value(forKey: "weight") != nil {
            let weight = UserDefaults.standard.value(forKey: "weight") as! Double
            
            return String(format: "%.0f", weight * 2.2)
        } else {
            return ""
        }
        
    }
    
    // table view datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrayList?.count)!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableList.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.setInfo(array: arrayList!, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let dicList = arrayList![indexPath.row] as! NSDictionary
        self.delegate?.didTapButtonAtHomeViewController(dic: dicList, index: indexPath.row)
    }
    
}

extension AtHomeViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
}
