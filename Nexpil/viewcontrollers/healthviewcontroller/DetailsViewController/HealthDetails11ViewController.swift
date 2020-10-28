//
//  HealthDetails11ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

class HealthDetails11ViewController: UIViewController,
    CAPSPageMenuDelegate,
    PopupAlertViewControllerDelegate,
    SubDetails110ViewControllerDelegate,
    SubDetails111ViewControllerDelegate,
    SubDetails112ViewControllerDelegate,
    SubDetails113ViewControllerDelegate,
    ScanLipidPanelViewControllerDelegate

{

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bgPageView: UIView!
    
    var pageMenu:CAPSPageMenu?
    var controller0 = SubDetails110ViewController()
    var controller1 = SubDetails111ViewController()
    var controller2 = SubDetails112ViewController()
    var controller3 = SubDetails113ViewController()
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
        lblTitle.font = UIFont.init(name: "Montserrat-Bold", size: 40)

        // array
        arrayAtHome = NSMutableArray.init()
        arrayLabs = NSMutableArray.init()
        currentPage = 0
        
    }
    
    // Content Viewcontroller
    func initContentViewControllers() {
        let arrayController: NSMutableArray = NSMutableArray.init()
        controller0 = SubDetails110ViewController(nibName: "SubDetails110ViewController", bundle: nil)
        controller1 = SubDetails111ViewController(nibName: "SubDetails111ViewController", bundle: nil)
        controller2 = SubDetails112ViewController(nibName: "SubDetails112ViewController", bundle: nil)
        controller3 = SubDetails113ViewController(nibName: "SubDetails113ViewController", bundle: nil)
        
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
            title0 = "  HDL"
            title1 = "          LDL"
            title2 = "     Triglycerides "
            title3 = "                   Total"

        } else {
            title0 = "HDL"
            title1 = "LDL"
            title2 = "Triglycerides"
            title3 = "Total"
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
            CAPSPageMenuOptionSelectionIndicatorColor: UIColor.init(hexString: "4939e3"),
            CAPSPageMenuOptionSelectedMenuItemLabelColor: UIColor.init(hexString: "4939e3"),
            CAPSPageMenuOptionMenuItemFont: UIFont.init(name: "Montserrat", size: 12.0),
            CAPSPageMenuOptionMenuHeight: 25,
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
        popupAlertViewController.index = 4
        
        UIApplication.shared.keyWindow?.addSubview((popupAlertViewController.view)!)
    }
    
    // MARK - PopupAlertViewController Delegate
    func didTapButtonClosePopupAlertViewController() {
        popupAlertViewController.view.removeFromSuperview()
    }
    
    // MARK - SubDetails110ViewController delegate
    func didTapButtonAddWithSubDetails110ViewController() {
        self.loadScanLipidPanelViewController(index: "HDL")
    }
    
    // MARK - SubDetails111ViewController delegate
    func didTapButtonAddWithSubDetails111ViewController() {
        self.loadScanLipidPanelViewController(index: "LDL")
    }
    
    // MARK - SubDetails112ViewController delegate
    func didTapButtonAddWithSubDetails112ViewController() {
        self.loadScanLipidPanelViewController(index: "Triglycerides")
    }
    
    // MARK - SubDetails113ViewController delegate
    func didTapButtonAddWithSubDetails113ViewController() {
        self.loadScanLipidPanelViewController(index: "Total")
    }
    
    func loadScanLipidPanelViewController(index: String) {
        let scanLipidPanelViewController = (self.storyboard?.instantiateViewController(withIdentifier: "ScanLipidPanelViewController") as? ScanLipidPanelViewController)!
        scanLipidPanelViewController.Index = index
        scanLipidPanelViewController.delegate = self
        self.present(scanLipidPanelViewController, animated: true, completion: nil)
    }

    // MARK - ScanLipidPanelViewController Delegate
    func didTapButtonDonePopupScanLipidPanelViewController(date: Date, value: NSInteger, index: String) {
        // insert
        if index == "HDL" {
            controller0.insertLipidPanel(date: date, value: value, index: index)
            
        } else if index == "LDL" {
            controller1.insertLipidPanel(date: date, value: value, index: index)

        } else if index == "Triglycerides" {
            controller2.insertLipidPanel(date: date, value: value, index: index)

        } else if index == "Total" {
            controller3.insertLipidPanel(date: date, value: value, index: index)

        }
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
