//
//  HealthDetails03ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

class HealthDetails03ViewController: UIViewController,
    PopupMoodViewControllerDelegate,
    MoodTableViewCell2Delegate,
    UITableViewDelegate,
    UITableViewDataSource
{

    

    var popupMoodViewController = PopupMoodViewController()
    var arrayList = NSArray()
    let manager = DataManager()
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableList: UITableView!
    
    
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
        self.fetchMood()
        
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
            return 200
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
            cell.setInfo(index: 3)
            
            return cell
            
        } else {
            if arrayList.count > 0 {
                let mood = arrayList[indexPath.row - 1] as! Mood
            
                tableView.register(UINib(nibName: "MoodTableViewCell2", bundle: nil), forCellReuseIdentifier: "MoodTableViewCell2")
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoodTableViewCell2", for: indexPath) as! MoodTableViewCell2
                cell.selectionStyle = .default
                cell.delegate = self
                cell.index = indexPath.row - 1
                cell.setInfo(dic: mood)
            
                return cell
            } else {
                return UITableViewCell.init()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
        
        if indexPath.row == 0 {
            sleep(UInt32(0.5))
            
            popupMoodViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupMoodViewController") as? PopupMoodViewController)!
            popupMoodViewController.delegate = self
            popupMoodViewController.isNew = true
            UIApplication.shared.keyWindow?.addSubview((popupMoodViewController.view)!)
            
        } else {
            popupMoodViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupMoodViewController") as? PopupMoodViewController)!
            popupMoodViewController.delegate = self
            popupMoodViewController.isNew = false
            popupMoodViewController.isEdit = true
            popupMoodViewController.dicMood = arrayList[indexPath.row - 1] as! Mood
            UIApplication.shared.keyWindow?.addSubview((popupMoodViewController.view)!)
        }
        
    }

    // MARK - PopupMoodViewContoller delegate
    func didTapButtonClosePopupMoodViewController() {
        popupMoodViewController.view.removeFromSuperview()
    }
    
    func didTapButtonDonePopupMoodViewController(date: Date, feeling: NSInteger, notes: String) {
        popupMoodViewController.view.removeFromSuperview()

        print(">>> date:", date)
        print(">>> feeling:", feeling)
        print(">>> notes:", notes)
        
        self.saveMoodDataToCoreData(date: date, feeling: feeling, notes: notes)
    }
    
    // MARK - MoodTableViewCell Delegate
    func didTapButtonEditMoodDetailsCell(index: NSInteger) {
        popupMoodViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupMoodViewController") as? PopupMoodViewController)!
        popupMoodViewController.delegate = self
        popupMoodViewController.dicMood = arrayList[index] as! Mood
        popupMoodViewController.isEdit = true
        UIApplication.shared.keyWindow?.addSubview((popupMoodViewController.view)!)

    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK - save to CoreData
    func saveMoodDataToCoreData(date: Date, feeling: NSInteger, notes: String) {
        SVProgressHUD.show()
        
        let result = manager.insertMood(date: date, feeling: feeling, notes: notes)
        
        SVProgressHUD.dismiss()
        if result == true {
            print(">>>> save mood sucess")
            self.fetchMood()
            
        } else {
            print(">>> saved mood error")
        }
    }
    
    
    // fetch mood from CoreData
    func fetchMood() {
        SVProgressHUD.show()
        
        let array = manager.fetchMood()
        
        SVProgressHUD.dismiss()
        if array.count > 0 {
            arrayList = array
            tableList.reloadData()
        }
    }
}
