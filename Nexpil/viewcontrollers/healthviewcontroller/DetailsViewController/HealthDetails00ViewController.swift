//
//  HealthDetails00ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import SVProgressHUD

class HealthDetails00ViewController: UIViewController,
    CAPSPageMenuDelegate,
    PopupAlertViewControllerDelegate,
    PopupBloodGlucoseViewControllerDelegate,
    AddManuallyBloodGlucoseViewControllerDelegate,
    SubDetails000ViewControllerDelegate,
    SubDetails001ViewControllerDelegate,
    SubDetails002ViewControllerDelegate,
    SubDetails003ViewControllerDelegate,
    ScanBloodGlucoseViewControllerDelegate

{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bgPageView: UIView!
    
    var pageMenu:CAPSPageMenu?
    var controller0 = SubDetails000ViewController()
    var controller1 = SubDetails001ViewController()
    var controller2 = SubDetails002ViewController()
    var controller3 = SubDetails003ViewController()
    var currentPage = NSInteger()
    var arrayAtHome = NSMutableArray()
    var arrayLabs = NSMutableArray()
    var popupAlertViewController = PopupAlertViewController()
    var popupBloodGlucoseViewController = PopupBloodGlucoseViewController()
    var addManuallyBloodGlucoseViewController = AddManuallyBloodGlucoseViewController()
    var addManuallyBloodPressureViewController = AddManuallyBloodPressureViewController()
    
    var manager = DataManager()

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
        controller0 = SubDetails000ViewController(nibName: "SubDetails000ViewController", bundle: nil)
        controller1 = SubDetails001ViewController(nibName: "SubDetails001ViewController", bundle: nil)
        controller2 = SubDetails002ViewController(nibName: "SubDetails002ViewController", bundle: nil)
        controller3 = SubDetails003ViewController(nibName: "SubDetails003ViewController", bundle: nil)

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
            CAPSPageMenuOptionSelectionIndicatorColor: UIColor.init(hexString: "397ee3"),
            CAPSPageMenuOptionSelectedMenuItemLabelColor: UIColor.init(hexString: "397ee3"),
            CAPSPageMenuOptionMenuItemFont: UIFont.init(name: "Montserrat", size: 16.0),
            CAPSPageMenuOptionMenuHeight: 40,
            CAPSPageMenuOptionMenuItemWidth: self.view.frame.size.width / 4,
            CAPSPageMenuOptionCenterMenuItems: true,
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
        popupAlertViewController.index = 0
        
        UIApplication.shared.keyWindow?.addSubview((popupAlertViewController.view)!)
    }
    
    // MARK - PopupAlertViewController Delegate
    func didTapButtonClosePopupAlertViewController() {
        popupAlertViewController.view.removeFromSuperview()
    }
    
    // MARK - SubDetails000ViewController delegate
    func didTapButtonAddWithSubDetails000ViewController() {
        self.loadScanBloodGlucoseViewController()
    }
    
    func didTapButtonUpdateWithSubDetails000ViewController(index: NSInteger, sendDic: NSDictionary) {
        // load popup bloodGlucose
//        self.loadPopupBloodGlucoseViewController(index: index, sendDic: sendDic)
        self.loadAddManuallyBloodGlucoseViewController(index: index, sendDic: sendDic)
        
    }
    
    // MARK - PopupBloodGlucoseViewController delegate
    func didTapButtonClosePopupBloodGlucoseViewController() {
        popupBloodGlucoseViewController.view.removeFromSuperview()
    }
    
    func didTapButtonErrorPopupBloodGlucoseViewController(error: String) {
        self.loadAlertController(message: error)
    }
    
    func didTapButtonDonePopupBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger) {
        popupBloodGlucoseViewController.view.removeFromSuperview()
        controller0.insertBloodGlucose(date: date, whenIndex: whenIndex, value: value)
    }
    
    // MARK - SubDetails001ViewController delegate
    func didTapButtonAddWithSubDetails001ViewController() {
//        self.loadScanBloodGlucoseViewController(index: 1)
    }
    
    // MARK - SubDetails002ViewController delegate
    func didTapButtonAddWithSubDetails002ViewController() {
//        self.loadScanBloodGlucoseViewController(index: 2)
    }
    
    // MARK - SubDetails003ViewController delegate
    func didTapButtonAddWithSubDetails003ViewController() {
//        self.loadScanBloodGlucoseViewController(index: 3)
    }
    
    func loadScanBloodGlucoseViewController() {
        let scanBloodGlucoseViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ScanBloodGlucoseViewController") as? ScanBloodGlucoseViewController)!
        scanBloodGlucoseViewController.delegate = self
        self.present(scanBloodGlucoseViewController, animated: true, completion: nil)
    }
    
    func loadPopupBloodGlucoseViewController(index: NSInteger, sendDic: NSDictionary) {
        popupBloodGlucoseViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupBloodGlucoseViewController") as? PopupBloodGlucoseViewController)!
        popupBloodGlucoseViewController.delegate = self
        popupBloodGlucoseViewController.isNew = false
        popupBloodGlucoseViewController.index = index
        popupBloodGlucoseViewController.sendDic = sendDic
        
        UIApplication.shared.keyWindow?.addSubview((popupBloodGlucoseViewController.view)!)
    }
    
    // MARK - ScanBloodGlucoseViewController delegate
    func didTapButtonAddGlucoseScanBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger) {
        // messaging to
        controller0.insertBloodGlucose(date: date, whenIndex: whenIndex, value: value)
    }
    
    func loadAddManuallyBloodGlucoseViewController(index: NSInteger, sendDic: NSDictionary) {
        addManuallyBloodGlucoseViewController = (self.storyboard?.instantiateViewController(withIdentifier: "AddManuallyBloodGlucoseViewController") as? AddManuallyBloodGlucoseViewController)!
        addManuallyBloodGlucoseViewController.delegate = self
        addManuallyBloodGlucoseViewController.isNew = false
        addManuallyBloodGlucoseViewController.index = index
        addManuallyBloodGlucoseViewController.sendDic = sendDic
        
        self.present(addManuallyBloodGlucoseViewController, animated: true, completion: nil)
//        UIApplication.shared.keyWindow?.addSubview((popupBloodGlucoseViewController.view)!)
    }

    // MARK - AddManuallyBloodGlucoseViewController delegate
    func didTapButtonDoneAddManuallyBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger) {
        controller0.insertBloodGlucose(date: date, whenIndex: whenIndex, value: value)
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
