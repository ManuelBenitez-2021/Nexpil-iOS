//
//  LabsViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import XLPagerTabStrip

protocol LabsViewControllerDelegate: class {
    func didTapButtonLabsViewController(dic: NSDictionary, index: NSInteger)
}

class LabsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate:LabsViewControllerDelegate?
    
    @IBOutlet weak var tableList: UITableView!
    var arrayList: NSMutableArray?
    var manager = DataManager()
    
    let tabTitle = "Labs"
    
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
        
        self.initMainView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getSelfData()
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
        self.getSelfData()
        self.tableList.reloadData()
        refreshControl.endRefreshing()
    }
    
    func getSelfData() {
        // array
        arrayList = NSMutableArray.init()
        let hemoglobin = self.getHemoglobinAlc()
        let lipid = self.getLipidPanel()
        let inr = self.getINR()
        
        
        let dic0 = NSDictionary.init(objects: ["Hemoglobin A1c", "Hemoglobin A1c", hemoglobin, "%"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        let dic1 = NSDictionary.init(objects: ["Lipid Panel", "Lipid Panel", lipid, "mg/dl"], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        let dic2 = NSDictionary.init(objects: ["INR", "INR", inr, ""], forKeys: ["title" as NSString, "image" as NSString, "value" as NSString, "unit" as NSString])
        
        arrayList = NSMutableArray.init(array: [dic0, dic1, dic2])
        
    }
    
    func getHemoglobinAlc() -> String {
        let array = manager.fetchHemoglobinAlc()
        if array.count > 0 {
            let data = array[0] as! HemoglobinAlc
            let value = data.value
            
            return String(format: "%0.1f", value)
        } else {
            return "0.0"
        }
    }
    
    func getLipidPanel() -> String {
        let array = manager.fetchLipidPanelGetAllYearData(index: "HDL")
        if array.count > 0 {
            let data = ((array[0] as! NSDictionary)["data"] as! NSArray)[0] as! NSDictionary
            let value = (data["average"] as! NSNumber).stringValue
            
            return String(format: "%@", value)
        } else {
            return "00"
        }
    }
    
    func getINR() -> String {
        let array = manager.fetchINR()
        if array.count > 0 {
            let data = array[0] as! INR
            let value = data.value
            
            return String(format: "%0.1f", value)
        } else {
            return "0.0"
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
        let cell:CategoryTableViewCell = tableList.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.setInfo(array: arrayList!, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let dicList = arrayList![indexPath.row] as! NSDictionary
        self.delegate?.didTapButtonLabsViewController(dic: dicList, index: indexPath.row)
    }
    
}
extension LabsViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabTitle)
    }
}
