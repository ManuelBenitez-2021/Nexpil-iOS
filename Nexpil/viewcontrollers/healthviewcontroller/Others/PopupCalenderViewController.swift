//
//  PopupCalenderViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import FSCalendar

protocol PopupCalenderViewControllerDelegate: class {
    func didTapButtonClosePopupCalenderViewController()
    func didTapButtonChooseDatePopupCalenderViewController(date: Date)
}

class PopupCalenderViewController: UIViewController, FSCalendarDelegate,
    FSCalendarDataSource,
    FSCalendarDelegateAppearance
{

    weak var delegate:PopupCalenderViewControllerDelegate?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var contentView: UIView!
    
    
    var dateFormatter = DateFormatter()
    var index = NSInteger()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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

    func initMainView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true;
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = NSLocale.init(localeIdentifier: "en") as Locale
        
        calendar.appearance.headerTitleFont = UIFont.init(name: "Montserrat", size: 24)
        calendar.appearance.weekdayFont = UIFont.init(name: "Montserrat", size: 12)
        calendar.appearance.headerTitleColor = UIColor.black
        
        calendar.appearance.weekdayTextColor = UIColor.init(hexString: "4939E3")
        calendar.appearance.selectionColor = UIColor.clear
        
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        var strTitle = ""
        
        if index == 0 {
            strTitle = "Blood Glucose"
            
        } else if index == 1 {
            strTitle = "Blood Pressure"
            
        } else if index == 2 {
            strTitle = "Oxygen Level"
            
        } else if index == 3 {
            strTitle = "Mood"
            calendar.appearance.todayColor = UIColor.init(hexString: "397EE3")

        } else if index == 4 {
            strTitle = "Hemoglobin A1c"
            
        } else if index == 5 {
            strTitle = "Lipid Panel"
            calendar.appearance.todayColor = UIColor.init(hexString: "4939e3")

        } else if index == 6 {
            strTitle = "INR"
            calendar.appearance.todayColor = UIColor.init(hexString: "397EE3")

        }

        lblTitle.text = strTitle
        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        
    }

    // MARK - FSCalendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // selection color
        if date != Date() {
            calendar.appearance.titleTodayColor = UIColor.black
        }
        calendar.appearance.todayColor = UIColor.clear
        
        if index == 3 {
            calendar.appearance.selectionColor = UIColor.init(hexString: "397EE3")
        } else if index == 5 {
            calendar.appearance.selectionColor = UIColor.init(hexString: "4939e3")
        } else if index == 6 {
            calendar.appearance.selectionColor = UIColor.init(hexString: "397EE3")
        }
        
        let strSendDate = dateFormatter.string(from: date)
        self.delegate?.didTapButtonChooseDatePopupCalenderViewController(date: date)
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupCalenderViewController()
    }
    
    
}
