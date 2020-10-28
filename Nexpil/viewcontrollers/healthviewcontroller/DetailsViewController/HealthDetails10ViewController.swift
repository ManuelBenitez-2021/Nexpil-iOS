//
//  HealthDetails10ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol HealthDetails10ViewControllerDelegate: class {
//    func didTapButtonAddWithHealthDetails10ViewController()
}

class HealthDetails10ViewController: UIViewController,
    PopupAlertViewControllerDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    ScanHemoglobinAlcViewControllerDelegate
{

    weak var delegate:HealthDetails10ViewControllerDelegate?

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableList: UITableView!
    var popupAlertViewController = PopupAlertViewController()
    var arrayList = NSArray()
    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.initMainView()
        
        // set code
//        self.loadPopupAlertViewController()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchHemoglobinAlc()
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
        lblTitle.font = UIFont.init(name: "Montserrat-Bold", size: 40)
    }
    
    // MARK - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        } else {
            return 815
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
            cell.setInfo(index: 6)
            
            return cell
            
        } else {
            if arrayList.count > 0 {
                let dicList = arrayList[indexPath.row - 1] as! NSDictionary
            
                tableView.register(UINib(nibName: "HemoglobinAlcTableViewCell", bundle: nil), forCellReuseIdentifier: "HemoglobinAlcTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "HemoglobinAlcTableViewCell", for: indexPath) as! HemoglobinAlcTableViewCell
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
                self.loadScanHemoglobinAlcViewController()
            
        } else {
            //            let videoDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as? VideoDetailViewController
            //            videoDetailViewController?.dicVideo = arrayVideos[indexPath.row] as! NSDictionary
            //            self.navigationController?.pushViewController(videoDetailViewController!, animated: true)
        }
        
    }

    func loadScanHemoglobinAlcViewController() {
        let scanHemoglobinAlcViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ScanHemoglobinAlcViewController") as? ScanHemoglobinAlcViewController)!
        scanHemoglobinAlcViewController.delegate = self
        self.present(scanHemoglobinAlcViewController, animated: true, completion: nil)
    }
    
    // MARK - ScanHemoglobinViewCOntrolelr delegate
    func didTapButtonAddScanHemoglobinAlcViewController(date: Date, value: Float) {
        // insert to db
        self.insertHemoglobinAlc(date: date, value: value)
    }
    
    func loadPopupAlertViewController() {
        sleep(UInt32(0.5))
        
        popupAlertViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupAlertViewController") as? PopupAlertViewController)!
        popupAlertViewController.delegate = self
        popupAlertViewController.index = 3
        
        UIApplication.shared.keyWindow?.addSubview((popupAlertViewController.view)!)
    }
    
    // MARK - PopupAlertViewController Delegate
    func didTapButtonClosePopupAlertViewController() {
        popupAlertViewController.view.removeFromSuperview()
    }

    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK - insert
    func insertHemoglobinAlc(date: Date, value: Float) {
        SVProgressHUD.show()
        let retult = manager.insertHemoglobinHlc(date: date, value: value)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchHemoglobinAlc()
        } else {
            
        }
        
    }
    
    func fetchHemoglobinAlc() {
        SVProgressHUD.show()
        
        let array = manager.fetchHemoglobinHlcGetAllYearData()
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            tableList.reloadData()
        }
    }
    
}
