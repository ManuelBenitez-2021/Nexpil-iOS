//
//  HealthDetails04ViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/28.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

class HealthDetails04ViewController: UIViewController, CAPSPageMenuDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var bgPageView: UIView!
    
    var pageMenu:CAPSPageMenu?
    var controller0 = SubDetails040ViewController()
    var controller1 = SubDetails041ViewController()
    var controller2 = SubDetails042ViewController()
    var controller3 = SubDetails043ViewController()
    var currentPage = NSInteger()
    var arrayAtHome = NSMutableArray()
    var arrayLabs = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        self.initContentViewControllers()
        
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
        controller0 = SubDetails040ViewController(nibName: "SubDetails040ViewController", bundle: nil)
        controller1 = SubDetails041ViewController(nibName: "SubDetails041ViewController", bundle: nil)
        controller2 = SubDetails042ViewController(nibName: "SubDetails042ViewController", bundle: nil)
        controller3 = SubDetails043ViewController(nibName: "SubDetails043ViewController", bundle: nil)
        
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
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
