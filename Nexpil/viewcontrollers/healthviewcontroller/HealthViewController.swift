//
//  HealthViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD
import XLPagerTabStrip

class HealthViewController: ButtonBarPagerTabStripViewController,
    AtHomeViewControllerDelegate,
    LabsViewControllerDelegate,
    UITabBarControllerDelegate
{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bgPageView: UIView!
    
    @IBOutlet weak var m_vwRadialRight: UIView!
    @IBOutlet weak var m_vwRadialLeft: UIView!
    
    @IBOutlet weak var m_vwTopNavBar: UIView!
    @IBOutlet weak var m_vwTopContainer: UIView!
    
    @IBOutlet weak var m_vwAtHome: UIView!
    @IBOutlet weak var m_ivAtHome: UIImageView!
    
    @IBOutlet weak var m_vwLabs: UIView!
    @IBOutlet weak var m_ivLabs: UIImageView!
    
    var oldCell:ButtonBarViewCell?
    var newCell:ButtonBarViewCell?
    
    var navIVArray: [UIImageView] = []
    var topNavActiveArray: [String] = []
    var topNavDeactiveArray: [String] = []
    
    var pageMenu:CAPSPageMenu?
    var child_1: AtHomeViewController = AtHomeViewController()
    var child_2:LabsViewController = LabsViewController()
    var currentPage = NSInteger()
    var arrayAtHome = NSMutableArray()
    var arrayLabs = NSMutableArray()
    var manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        initNavBar()
        
        self.view.backgroundColor = UIColor.init(hexString: "#F7F7F7")
        
        // Do any additional setup after loading the view.
        containerView.isScrollEnabled = false
        barSettings()
        
        self.tabBarController?.delegate = self
        
        self.buttonBarView.backgroundColor = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // auth
        manager.authorizeHealthKit()

        // update
        manager.updateHealthInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        m_vwRadialLeft.layer.cornerRadius = m_vwRadialLeft.frame.width / 2
        m_vwRadialRight.layer.cornerRadius = m_vwRadialRight.frame.width / 2
        
    }
    
    func initNavBar() {
        
        navIVArray = [m_ivAtHome, m_ivLabs]
        topNavActiveArray = ["icon_at_home_active", "icon_labs_active"]
        topNavDeactiveArray = ["icon_at_home_deactive", "icon_labs_deactive"]
        
        selectNavItem(position: 0)
    }
    
    func selectNavItem(position: Int) {
        
        for i in 0...1 {
            
            if (i != position) {
                navIVArray[i].image = UIImage.init(named: topNavDeactiveArray[i])
            }
        }
        
        navIVArray[position].image = UIImage.init(named: topNavActiveArray[position])
        moveToViewController(at: position)
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        child_1 = AtHomeViewController(nibName: "AtHomeViewController", bundle: nil)
        child_1.delegate = self
        
        child_2 = LabsViewController(nibName: "LabsViewController", bundle: nil)
        child_2.delegate = self
        
        return [child_1, child_2]
        
    }
    
    func barSettings()
    {
        buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "39d3e3")
        settings.style.buttonBarBackgroundColor = UIColor.init(hex: "ffffff")
        settings.style.buttonBarItemBackgroundColor = UIColor.clear//init(hex: "f7f7fa")
        settings.style.selectedBarBackgroundColor = UIColor.init(hex: "ffffff")
        settings.style.buttonBarItemFont = UIFont(name: "Montserrat-Medium", size: 18)!
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.init(hex: "333333")
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        m_vwTopContainer.layer.cornerRadius = 15.0
        m_vwTopContainer.addShadow(color: #colorLiteral(red: 0.2384634067, green: 0.2384634067, blue: 0.2384634067, alpha: 1), alpha: 0.3, x: 0, y: 3, blur: 4.0)
        
        
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else {
                return }
            
            oldCell?.isSelected = false
            oldCell?.isHighlighted = false
            oldCell?.label.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
            
            self?.oldCell = oldCell
            //newCell?.label.textColor = UIColor.init(hex: "01A2DD")
            //oldCell?.imageView.image = oldCell?.imageView.image
            
            
            newCell?.isHighlighted = true
            newCell?.label.textColor = UIColor.init(hex: "39d3e3")
            
            self?.newCell = newCell
        }
        
        
    }
    

    // init MainView
    func initMainView() {
        lblTitle.font = UIFont.init(name: "Montserrat-Bold", size: 40)
        
    }

    func getNotifications() {
        let notificationKey1 = "sendSteps"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification1(notification:)), name: NSNotification.Name(rawValue: notificationKey1), object: nil)
        
        let notificationKey5 = "sendStepsHour"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification5(notification:)), name: NSNotification.Name(rawValue: notificationKey5), object: nil)

        let notificationKey2 = "sendBloodPressure"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification2(notification:)), name: NSNotification.Name(rawValue: notificationKey2), object: nil)

        let notificationKey3 = "sendBloodGlucose"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification3(notification:)), name: NSNotification.Name(rawValue: notificationKey3), object: nil)

        let notificationKey4 = "sendOxygenLevel"
        NotificationCenter.default.addObserver(self, selector: #selector(catchNotification4(notification:)), name: NSNotification.Name(rawValue: notificationKey4), object: nil)

    }
    
    @objc func catchNotification1(notification:Foundation.Notification) {
        let steps = notification.userInfo!["steps"] as! Double
        
        self.insertSteps(date: Date(), value: steps)
    }
    
    @objc func catchNotification5(notification:Foundation.Notification) {
        let steps = notification.userInfo!["steps"] as! Int64
        let hour = notification.userInfo!["hour"] as! NSInteger
        
        self.insertStepsHour(date: Date(), value: steps, hour: hour)
    }
    
    @objc func catchNotification2(notification:Foundation.Notification) {
        let bloodPressure1 = notification.userInfo!["bloodPressure1"] as! Double
        let bloodPressure2 = notification.userInfo!["bloodPressure2"] as! Double
        
        self.insertBloodPressure(date: Date(), value1: bloodPressure1, value2: bloodPressure2)
    }
    
    @objc func catchNotification3(notification:Foundation.Notification) {
        let value = notification.userInfo!["bloodGlucose"] as! NSInteger
        let whenIndex = notification.userInfo!["whenIndex"] as! String
        
        self.insertBloodGlucose(date: Date(), value: value, whenIndex: whenIndex)
    }
    
    @objc func catchNotification4(notification:Foundation.Notification) {
        let value = notification.userInfo!["oxygenLevel"] as! NSInteger
        let time = "8:00am"
        let timeIndex = "0"
        
        self.insertOxygenLevel(date: Date(), value: value, time: time, timeIndex: timeIndex)
    }
    
    
    
    // MARK - AtHomeViewController delegate
    func didTapButtonAtHomeViewController(dic: NSDictionary, index: NSInteger) {

        sleep(UInt32(0.5))
        
        if index == 0 {
            let healthDetails00ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails00ViewController") as! HealthDetails00ViewController
            self.present(healthDetails00ViewController, animated: true, completion: nil)
            
        } else if index == 1 {
            let healthDetails01ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails01ViewController") as! HealthDetails01ViewController
            self.present(healthDetails01ViewController, animated: true, completion: nil)
            
        } else if index == 2 {
            let healthDetails02ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails02ViewController") as! HealthDetails02ViewController
            self.present(healthDetails02ViewController, animated: true, completion: nil)
            
        } else if index == 3 {
            let healthDetails03ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails03ViewController") as! HealthDetails03ViewController
            self.present(healthDetails03ViewController, animated: true, completion: nil)

        } else if index == 4 {
            let healthDetails04ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails04ViewController") as! HealthDetails04ViewController
            self.present(healthDetails04ViewController, animated: true, completion: nil)
            
        } else if index == 5 {
            let healthDetails05ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails05ViewController") as! HealthDetails05ViewController
            self.present(healthDetails05ViewController, animated: true, completion: nil)
            
        }

    }
    
    func didTapButtonAtHomeViewControllerRefresh() {
        // update
        manager.updateHealthInfo()
    }
    
    // MARK - LabViewController Delegate
    func didTapButtonLabsViewController(dic: NSDictionary, index: NSInteger) {
        
        sleep(UInt32(0.5))

        if index == 0 {
            let healthDetails10ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails10ViewController") as! HealthDetails10ViewController
            self.present(healthDetails10ViewController, animated: true, completion: nil)
            
        } else if index == 1 {
            let healthDetails11ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails11ViewController") as! HealthDetails11ViewController
            self.present(healthDetails11ViewController, animated: true, completion: nil)
            
        } else if index == 2 {
            let healthDetails12ViewController = self.storyboard?.instantiateViewController(withIdentifier: "HealthDetails12ViewController") as! HealthDetails12ViewController
            self.present(healthDetails12ViewController, animated: true, completion: nil)
            
        }
        
    }
    
    private func displayAlert(for error: Error) {
        
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
   
    func insertSteps(date: Date, value: Double) {
//        SVProgressHUD.show()
        let retult = manager.insertSteps(date: date, value: value)
        
//        SVProgressHUD.dismiss()
        if retult == true {
            child_1.getSelfData()
            
        } else {
            
        }
    }
    
    func insertStepsHour(date: Date, value: Int64, hour: NSInteger) {
        let retult = manager.insertStepsHour(date: date, value: value, hour: hour)
        if retult == true {
            print(">>> insert step hour success, ", date, value, hour)
        } else {
            print(">>> insert step hour faild")
        }
    }
    
    func insertBloodPressure(date: Date, value1: Double, value2: Double) {
//        SVProgressHUD.show()
        
        let time = manager.getStrTime(date: date)
        let timeIndex = manager.getStrTimeIndex(date: date)
        
        let retult = manager.insertBloodPressure(date: date, time: time, timeIndex: timeIndex, value1: NSInteger(value1), value2: NSInteger(value2))
        
//        SVProgressHUD.dismiss()
        if retult == true {
            child_1.getSelfData()
            
        } else {
            
        }
    }
    
    func insertBloodGlucose(date: Date, value: NSInteger, whenIndex: String) {
//        SVProgressHUD.show()
        
        let retult = manager.insertBloodGlucose(date: date, whenIndex: whenIndex, value: value)
        
//        SVProgressHUD.dismiss()
        if retult == true {
            child_1.getSelfData()
            
        } else {
            
        }
    }
    
    func insertOxygenLevel(date: Date, value: NSInteger, time: String, timeIndex: String) {
//        SVProgressHUD.show()
        
        let retult = manager.insertOxygenLevel(date: date, time: time, timeIndex: timeIndex, value: value)
        
//        SVProgressHUD.dismiss()
        if retult == true {
            child_2.getSelfData()
            
        } else {
            
        }
    }
    
    
    @IBAction func tapNavHome(_ sender: Any) {
        self.selectNavItem(position: 0)
    }
    
    @IBAction func tapNavLabs(_ sender: Any) {
        self.selectNavItem(position: 1)
    }
    
    
}
