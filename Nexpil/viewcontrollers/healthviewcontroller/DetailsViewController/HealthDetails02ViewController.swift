//
//  HealthDetails02ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

class HealthDetails02ViewController: UIViewController,
    CAPSPageMenuDelegate,
    PopupAlertViewControllerDelegate,
    SubDetails020ViewControllerDelegate,
    SubDetails021ViewControllerDelegate,
    SubDetails022ViewControllerDelegate,
    SubDetails023ViewControllerDelegate,
    ScanOxygenLevelsViewControllerDelegate
    

{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bgPageView: UIView!
    
    var pageMenu:CAPSPageMenu?
    var controller0 = SubDetails020ViewController()
    var controller1 = SubDetails021ViewController()
    var controller2 = SubDetails022ViewController()
    var controller3 = SubDetails023ViewController()
    var currentPage = NSInteger()
    var arrayAtHome = NSMutableArray()
    var arrayLabs = NSMutableArray()
    var popupAlertViewController = PopupAlertViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        self.initContentViewControllers()

        // set code
//        self.loadPopupAlertViewController()
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
        // array
        arrayAtHome = NSMutableArray.init()
        arrayLabs = NSMutableArray.init()
        currentPage = 0
        lblTitle.font = UIFont.init(name: "Montserrat-Bold", size: 40)
    }
    
    // Content Viewcontroller
    func initContentViewControllers() {
        let arrayController: NSMutableArray = NSMutableArray.init()
        controller0 = SubDetails020ViewController(nibName: "SubDetails020ViewController", bundle: nil)
        controller1 = SubDetails021ViewController(nibName: "SubDetails021ViewController", bundle: nil)
        controller2 = SubDetails022ViewController(nibName: "SubDetails022ViewController", bundle: nil)
        controller3 = SubDetails023ViewController(nibName: "SubDetails023ViewController", bundle: nil)
        
        controller0.view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        controller1.view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        controller2.view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        controller3.view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        controller0.view.frame = self.bgPageView.frame
        controller1.view.frame = self.bgPageView.frame
        controller2.view.frame = self.bgPageView.frame
        controller3.view.frame = self.bgPageView.frame
        
        var title0 = String()
        var title1 = String()
        var title2 = String()
        var title3 = String()
        
        if (self.view.frame.size.width == 414) {
            title0 = "Day"
            title1 = "      Week"
            title2 = "          Month"
            title3 = "               Year"
            
        } else {
            title0 = "Day"
            title1 = "Week"
            title2 = "Month"
            title3 = "Year"
        }
        
        controller0.title = title0
        controller1.title = title1
        controller2.title = title2
        controller3.title = title3
        
        controller0.delegate = self
        controller1.delegate = self
        controller2.delegate = self
        controller3.delegate = self
        
        arrayController.add(controller0)
        arrayController.add(controller1)
        arrayController.add(controller2)
        arrayController.add(controller3)
        
        let parameters = [
            CAPSPageMenuOptionSelectionIndicatorHeight: 4,
            CAPSPageMenuOptionScrollMenuBackgroundColor: UIColor.white,
            CAPSPageMenuOptionSelectionIndicatorColor: UIColor.init(hexString: "39d3e3"),
            CAPSPageMenuOptionSelectedMenuItemLabelColor: UIColor.init(hexString: "39d3e3"),
            CAPSPageMenuOptionMenuItemFont: UIFont.init(name: "Montserrat", size: 16.0),
            CAPSPageMenuOptionMenuHeight: 40,
            CAPSPageMenuOptionUnselectedMenuItemLabelColor: UIColor.darkGray,
            CAPSPageMenuOptionUseMenuLikeSegmentedControl: true,
            CAPSPageMenuOptionMenuItemSeparatorPercentageHeight: 0.1,
            ] as NSDictionary
        
        pageMenu = CAPSPageMenu(viewControllers: arrayController as! [Any],
                                frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: self.bgPageView.frame.width,
                                              height: self.bgPageView.frame.height),
                                options: parameters as! [AnyHashable : Any])
        
        pageMenu?.delegate = self
        
        self.bgPageView.addSubview(pageMenu!.view)
        
    }
    
    // page menu view delegate
    func didMove(toPage controller: UIViewController!, index: Int) {
        currentPage = index
        //        self.requestGetEventMeList()
    }
    
    func loadPopupAlertViewController() {
        sleep(UInt32(0.5))
        
        popupAlertViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupAlertViewController") as? PopupAlertViewController)!
        popupAlertViewController.delegate = self
        popupAlertViewController.index = 2
        
        UIApplication.shared.keyWindow?.addSubview((popupAlertViewController.view)!)
    }
    
    // MARK - PopupAlertViewController Delegate
    func didTapButtonClosePopupAlertViewController() {
        popupAlertViewController.view.removeFromSuperview()
    }
    
    // MARK - SubDetails020ViewController delegate
    func didTapButtonAddWithSubDetails020ViewController() {
        self.loadScanOxygenLevelsViewController(index: 0)
    }
    
    // MARK - SubDetails021ViewController delegate
    func didTapButtonAddWithSubDetails021ViewController() {
        self.loadScanOxygenLevelsViewController(index: 1)
    }
    
    // MARK - SubDetails022ViewController delegate
    func didTapButtonAddWithSubDetails022ViewController() {
        self.loadScanOxygenLevelsViewController(index: 2)
    }
    
    // MARK - SubDetails023ViewController delegate
    func didTapButtonAddWithSubDetails023ViewController() {
        self.loadScanOxygenLevelsViewController(index: 3)
    }
    
    func loadScanOxygenLevelsViewController(index: NSInteger) {
        let scanOxygenLevelsViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ScanOxygenLevelsViewController") as? ScanOxygenLevelsViewController)!
        scanOxygenLevelsViewController.delegate = self
        self.present(scanOxygenLevelsViewController, animated: true, completion: nil)
    }
    
    // MARK - ScanOxygenViewController delegate
    func didTapButtonAddOxygenLevelViewController(date: Date, time: String, timeIndex: String, value: NSInteger) {
        // insert level
        controller0.insertOxygenLevel(date: date, time: time, timeIndex: timeIndex, value: value)
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
