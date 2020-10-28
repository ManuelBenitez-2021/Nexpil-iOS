//
//  HealthDetails12ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol HealthDetails12ViewControllerDelegate: class {
//    func didTapButtonAddHealthDetails12ViewController()
}

class HealthDetails12ViewController: UIViewController,
    PopupAlertViewControllerDelegate,
    PopupPopupINRViewControllerDelegate,
    UITableViewDelegate,
    UITableViewDataSource
{

    weak var delegate:HealthDetails12ViewControllerDelegate?

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableList: UITableView!
    var popupAlertViewController = PopupAlertViewController()
    var popupINRViewController = PopupINRViewController()
    var arrayList = NSArray()
    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        
        // set value
//        self.loadPopupAlertViewController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fetchINR()
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
            cell.setInfo(index: 8)
            
            return cell
            
        } else {
            if arrayList.count > 0 {
                let dicList = arrayList[indexPath.row - 1] as! NSDictionary
                
                tableView.register(UINib(nibName: "INRTableViewCell", bundle: nil), forCellReuseIdentifier: "INRTableViewCell")
                let cell = tableView.dequeueReusableCell(withIdentifier: "INRTableViewCell", for: indexPath) as! INRTableViewCell
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
            self.loadPopupINRViewController()
            
        } else {
            //            let videoDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as? VideoDetailViewController
            //            videoDetailViewController?.dicVideo = arrayVideos[indexPath.row] as! NSDictionary
            //            self.navigationController?.pushViewController(videoDetailViewController!, animated: true)
        }
        
    }
    
    func loadPopupAlertViewController() {
        sleep(UInt32(0.5))
        
        popupAlertViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupAlertViewController") as? PopupAlertViewController)!
        popupAlertViewController.delegate = self
        popupAlertViewController.index = 5
        
        UIApplication.shared.keyWindow?.addSubview((popupAlertViewController.view)!)
    }
    
    // MARK - PopupAlertViewController Delegate
    func didTapButtonClosePopupAlertViewController() {
        popupAlertViewController.view.removeFromSuperview()
    }


    func loadPopupINRViewController() {
        popupINRViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupINRViewController") as? PopupINRViewController)!
        popupINRViewController.delegate = self
        
        UIApplication.shared.keyWindow?.addSubview((popupINRViewController.view)!)
    }

    // MARK - PopupINRViewController Delegate
    func didTapButtonDonePopupINRViewController(date: Date, value: Float) {
        popupINRViewController.view.removeFromSuperview()
        self.insertINR(date: date, value: value)
    }
    
    func didTapButtonClosePopupINRViewController() {
        popupINRViewController.view.removeFromSuperview()
    }

    func didTapButtonErrorPopupINRViewController(error: String) {
        self.loadAlertController(message: error)
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK - insert
    func insertINR(date: Date, value: Float) {
        SVProgressHUD.show()
        let retult = manager.insertINR(date: date, value: value)
        
        SVProgressHUD.dismiss()
        if retult == true {
            self.fetchINR()
        } else {
            
        }
        
    }
    
    func fetchINR() {
        SVProgressHUD.show()
        
        let array = manager.fetchINRGetAllYearData()
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
