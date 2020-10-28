//
//  AddManuallyHemoglobinA1cViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/07/05.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import FSCalendar

protocol AddManuallyHemoglobinA1cViewControllerDelegate: class {
    func didTapButtonAddManuallyHemoglobinA1cViewController(date: Date,
                                                          time: String,
                                                          timeIndex: String,
                                                          value: String
    )
    
}

class AddManuallyHemoglobinA1cViewController: UIViewController,
UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    weak var delegate:AddManuallyHemoglobinA1cViewControllerDelegate?
    
    @IBOutlet weak var constraintScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var constraintViewContent: NSLayoutConstraint!
    
    @IBOutlet weak var viewValue: UIView!
    @IBOutlet weak var viewValueDetail: UIView!
    @IBOutlet weak var constraintViewValue: NSLayoutConstraint!
    @IBOutlet weak var constraintViewValueDetail: NSLayoutConstraint!
    
    @IBOutlet weak var viewWhen: UIView!
    @IBOutlet weak var viewWhenDetail: UIView!
    @IBOutlet weak var constraintViewWhen: NSLayoutConstraint!
    @IBOutlet weak var constraintViewWhenDetail: NSLayoutConstraint!
    
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewDateDetail: UIView!
    @IBOutlet weak var constraintViewDate: NSLayoutConstraint!
    @IBOutlet weak var constraintViewDateDetail: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var bgViewValue: UIView!
    @IBOutlet weak var bgViewUnit: UIView!
    @IBOutlet weak var btnValueNext: UIButton!
    
    @IBOutlet weak var lblTitleWhen: UILabel!
    @IBOutlet weak var lblWhen: UILabel!
    
    @IBOutlet weak var lblTitleViewWhenDetail: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblTitleSub1: UILabel!
    @IBOutlet weak var lblTitleSub2: UILabel!
    
    @IBOutlet weak var btnAM: UIButton!
    @IBOutlet weak var btnPM: UIButton!
    
    @IBOutlet weak var btnHour1: UIButton!
    @IBOutlet weak var btnHour2: UIButton!
    @IBOutlet weak var btnHour3: UIButton!
    @IBOutlet weak var btnHour4: UIButton!
    @IBOutlet weak var btnHour5: UIButton!
    @IBOutlet weak var btnHour6: UIButton!
    @IBOutlet weak var btnHour7: UIButton!
    @IBOutlet weak var btnHour8: UIButton!
    @IBOutlet weak var btnHour9: UIButton!
    @IBOutlet weak var btnHour10: UIButton!
    @IBOutlet weak var btnHour11: UIButton!
    @IBOutlet weak var btnHour12: UIButton!
    
    @IBOutlet weak var btnMinute00: UIButton!
    @IBOutlet weak var btnMinute05: UIButton!
    @IBOutlet weak var btnMinute10: UIButton!
    @IBOutlet weak var btnMinute15: UIButton!
    @IBOutlet weak var btnMinute20: UIButton!
    @IBOutlet weak var btnMinute25: UIButton!
    @IBOutlet weak var btnMinute30: UIButton!
    @IBOutlet weak var btnMinute35: UIButton!
    @IBOutlet weak var btnMinute40: UIButton!
    @IBOutlet weak var btnMinute45: UIButton!
    @IBOutlet weak var btnMinute50: UIButton!
    @IBOutlet weak var btnMinute55: UIButton!
    
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var btnDone: UIButton!
    
    var heightValueView = Float()
    var heightValueDetail = Float()
    var heightWhenView = Float()
    var heightWhenDetail = Float()
    var heightDateView = Float()
    var heightDateDetail = Float()
    var heightContentView = Float()
    
    var dateFormatter = DateFormatter()
    var sendDate = Date()
    var sendTime = String()
    var sendTimeIndex = String()
    var index1 = NSInteger()
    var index2 = NSInteger()
    var index3 = NSInteger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initMainView()
        self.setConstraintView0()
        self.setSelfData()
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
        // const
        heightValueView = 64
        heightValueDetail = 80
        heightWhenView = 64
        heightWhenDetail = 316
        heightDateView = 64
        heightDateDetail = 306
        heightContentView = 1122
        
        // font
        lblTitle.font = UIFont.init(name: "Montserrat", size: 38)
        lblSubTitle.font = UIFont.init(name: "Montserrat", size: 20)
        txtValue.font = UIFont.init(name: "Montserrat", size: 20)
        lblUnit.font = UIFont.init(name: "Montserrat", size: 20)
        btnValueNext.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        lblTitleWhen.font = UIFont.init(name: "Montserrat", size: 20)
        lblWhen.font = UIFont.init(name: "Montserrat", size: 17)
        
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 17)
        
        
        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        lblTitleViewWhenDetail.font = UIFont.init(name: "Montserrat", size: 17)
        lblTitleSub1.font = UIFont.init(name: "Montserrat", size: 12)
        lblTitleSub2.font = UIFont.init(name: "Montserrat", size: 12)
        
        lblTime.font = UIFont.init(name: "Montserrat", size: 30)
        btnAM.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnPM.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        btnHour1.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour2.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour3.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour4.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour5.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour6.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour7.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour8.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour9.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour10.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour11.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnHour12.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        
        btnMinute00.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute05.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute10.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute15.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute20.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute25.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute30.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute35.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute40.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute45.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute50.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        btnMinute55.titleLabel?.font = UIFont.init(name: "Montserrat", size: 15)
        
        // keyboard type
        txtValue.keyboardType = .numberPad
        txtValue.delegate = self
        
        // round view
        bgViewValue.layer.cornerRadius = 8
        bgViewValue.layer.masksToBounds = true;
        
        bgViewUnit.layer.cornerRadius = 8
        bgViewUnit.layer.masksToBounds = true;
        
        btnValueNext.layer.cornerRadius = 8
        btnValueNext.layer.masksToBounds = true;
        
        viewWhen.layer.cornerRadius = 8
        viewWhen.layer.masksToBounds = true;
        
        viewWhenDetail.layer.cornerRadius = 8
        viewWhenDetail.layer.masksToBounds = true;
        
        viewDate.layer.cornerRadius = 8
        viewDate.layer.masksToBounds = true;
        
        viewDateDetail.layer.cornerRadius = 8
        viewDateDetail.layer.masksToBounds = true;
        
        btnDone.layer.cornerRadius = 8
        btnDone.layer.masksToBounds = true;
        
        btnAM.layer.cornerRadius = 10
        btnAM.layer.masksToBounds = true;
        
        btnPM.layer.cornerRadius = 10
        btnPM.layer.masksToBounds = true;
        
        btnHour1.layer.cornerRadius = 5
        btnHour1.layer.masksToBounds = true;
        btnHour2.layer.cornerRadius = 5
        btnHour2.layer.masksToBounds = true;
        btnHour3.layer.cornerRadius = 5
        btnHour3.layer.masksToBounds = true;
        btnHour4.layer.cornerRadius = 5
        btnHour4.layer.masksToBounds = true;
        btnHour5.layer.cornerRadius = 5
        btnHour5.layer.masksToBounds = true;
        btnHour6.layer.cornerRadius = 5
        btnHour6.layer.masksToBounds = true;
        btnHour7.layer.cornerRadius = 5
        btnHour7.layer.masksToBounds = true;
        btnHour8.layer.cornerRadius = 5
        btnHour8.layer.masksToBounds = true;
        btnHour9.layer.cornerRadius = 5
        btnHour9.layer.masksToBounds = true;
        btnHour10.layer.cornerRadius = 5
        btnHour10.layer.masksToBounds = true;
        btnHour11.layer.cornerRadius = 5
        btnHour11.layer.masksToBounds = true;
        btnHour12.layer.cornerRadius = 5
        btnHour12.layer.masksToBounds = true;
        
        btnMinute00.layer.cornerRadius = 5
        btnMinute00.layer.masksToBounds = true;
        btnMinute05.layer.cornerRadius = 5
        btnMinute05.layer.masksToBounds = true;
        btnMinute10.layer.cornerRadius = 5
        btnMinute10.layer.masksToBounds = true;
        btnMinute15.layer.cornerRadius = 5
        btnMinute15.layer.masksToBounds = true;
        btnMinute20.layer.cornerRadius = 5
        btnMinute20.layer.masksToBounds = true;
        btnMinute25.layer.cornerRadius = 5
        btnMinute25.layer.masksToBounds = true;
        btnMinute30.layer.cornerRadius = 5
        btnMinute30.layer.masksToBounds = true;
        btnMinute35.layer.cornerRadius = 5
        btnMinute35.layer.masksToBounds = true;
        btnMinute40.layer.cornerRadius = 5
        btnMinute40.layer.masksToBounds = true;
        btnMinute45.layer.cornerRadius = 5
        btnMinute45.layer.masksToBounds = true;
        btnMinute50.layer.cornerRadius = 5
        btnMinute50.layer.masksToBounds = true;
        btnMinute55.layer.cornerRadius = 5
        btnMinute55.layer.masksToBounds = true;
        
        // TAG
        btnHour1.tag = 0
        btnHour2.tag = 1
        btnHour3.tag = 2
        btnHour4.tag = 3
        btnHour5.tag = 4
        btnHour6.tag = 5
        btnHour7.tag = 6
        btnHour8.tag = 7
        btnHour9.tag = 8
        btnHour10.tag = 9
        btnHour11.tag = 10
        btnHour12.tag = 11
        
        btnMinute00.tag = 0
        btnMinute05.tag = 1
        btnMinute10.tag = 2
        btnMinute15.tag = 3
        btnMinute20.tag = 4
        btnMinute25.tag = 5
        btnMinute30.tag = 6
        btnMinute35.tag = 7
        btnMinute40.tag = 8
        btnMinute45.tag = 9
        btnMinute50.tag = 10
        btnMinute55.tag = 11
        
        // calendar
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = NSLocale.init(localeIdentifier: "en") as Locale
        
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        calendar.appearance.headerTitleFont = UIFont.init(name: "Montserrat", size: 24)
        calendar.appearance.weekdayFont = UIFont.init(name: "Montserrat", size: 12)
        calendar.appearance.headerTitleColor = UIColor.black
        
        calendar.appearance.weekdayTextColor = UIColor.init(hexString: "4939E3")
        calendar.appearance.todayColor = UIColor.init(hexString: "39D3E3")
        calendar.appearance.selectionColor = UIColor.clear
    }
    
    func setSelfData() {
        let date = Date()
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
        sendDate = date
        
        sendTimeIndex = "0"
        index1 = 0
        index2 = 0
        index3 = 0
        self.setTimeTitle(idx1: index1, idx2: index2, idx3: index3)
        
    }
    
    func setTimeTitle(idx1: NSInteger, idx2: NSInteger, idx3: NSInteger) {
        let strColorPurple = "39D3E3"
        let strColorWhite = "FFFFFF"
        let strColorLightGray = "EBEBF1"
        let strColorGray = "333333"
        
        if idx1 == 0 {
            self.resetAllHourButtons()
            btnHour1.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour1.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 1 {
            self.resetAllHourButtons()
            btnHour2.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour2.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 2 {
            self.resetAllHourButtons()
            btnHour3.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour3.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 3 {
            self.resetAllHourButtons()
            btnHour4.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour4.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 4 {
            self.resetAllHourButtons()
            btnHour5.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour5.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 5 {
            self.resetAllHourButtons()
            btnHour6.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour6.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 6 {
            self.resetAllHourButtons()
            btnHour7.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour7.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 7 {
            self.resetAllHourButtons()
            btnHour8.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour8.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 8 {
            self.resetAllHourButtons()
            btnHour9.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour9.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 9 {
            self.resetAllHourButtons()
            btnHour10.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour10.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 10 {
            self.resetAllHourButtons()
            btnHour11.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour11.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx1 == 11 {
            self.resetAllHourButtons()
            btnHour12.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnHour12.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        }
        
        if idx2 == 0 {
            self.resetAllMinuteButtons()
            btnMinute00.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute00.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 1 {
            self.resetAllMinuteButtons()
            btnMinute05.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute05.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 2 {
            self.resetAllMinuteButtons()
            btnMinute10.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute10.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 3 {
            self.resetAllMinuteButtons()
            btnMinute15.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute15.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 4 {
            self.resetAllMinuteButtons()
            btnMinute20.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute20.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 5 {
            self.resetAllMinuteButtons()
            btnMinute25.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute25.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 6 {
            self.resetAllMinuteButtons()
            btnMinute30.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute30.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 7 {
            self.resetAllMinuteButtons()
            btnMinute35.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute35.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 8 {
            self.resetAllMinuteButtons()
            btnMinute40.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute40.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 9 {
            self.resetAllMinuteButtons()
            btnMinute45.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute45.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 10 {
            self.resetAllMinuteButtons()
            btnMinute50.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute50.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        } else if idx2 == 11 {
            self.resetAllMinuteButtons()
            btnMinute55.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnMinute55.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        }
        
        if idx3 == 0 {
            btnAM.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnAM.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            btnPM.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnPM.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
            
        } else {
            btnPM.backgroundColor = UIColor.init(hexString: strColorPurple)
            btnPM.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            btnAM.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnAM.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        }
        
        let arrayTime1 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        let arrayTime2 = ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
        let arrayTime3 = ["am", "pm"]
        
        sendTime = arrayTime1[index1] + ":" + arrayTime2[index2] + arrayTime3[index3]
        lblWhen.text = sendTime
        lblTime.text = arrayTime1[index1] + ":" + arrayTime2[index2]
        
        if index3 == 0 && index1 <= 10 {
            sendTimeIndex = "0"
        } else if (index3 == 0 && index1 == 11) || (index3 == 1 && (index1 == 11 || index1 <= 2))  {
            sendTimeIndex = "1"
        } else {
            sendTimeIndex = "2"
        }
        
    }
    
    func resetAllHourButtons() {
        let strColorLightGray = "EBEBF1"
        let strColorGray = "333333"
        
        btnHour1.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour1.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour2.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour2.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour3.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour3.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour4.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour4.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour5.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour5.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour6.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour6.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour7.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour7.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour8.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour8.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour9.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour9.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour10.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour10.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour11.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour11.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnHour12.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnHour12.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
    }
    
    func resetAllMinuteButtons() {
        let strColorLightGray = "EBEBF1"
        let strColorGray = "333333"
        
        btnMinute00.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute00.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute05.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute05.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute10.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute10.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute15.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute15.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute20.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute20.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute25.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute25.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute30.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute30.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute35.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute35.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute40.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute40.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute45.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute45.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute50.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute50.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnMinute55.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnMinute55.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
    }
    
    
    func setConstraintView0() {
        btnValueNext.isHidden = true
        
        constraintViewContent.constant = CGFloat(heightContentView)
        constraintViewValue.constant = CGFloat(heightValueView)
        constraintViewWhen.constant = CGFloat(heightWhenView)
        constraintViewDate.constant = CGFloat(heightDateView)
        
        constraintViewValueDetail.constant = 0
        constraintViewWhenDetail.constant = 0
        constraintViewDateDetail.constant = 0
        
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight - 78 - 200
        let contentViewHeight = constraintViewContent.constant - CGFloat(
            heightValueDetail +
                heightWhenDetail +
            heightDateDetail
        )
        let maxHeight = max(height, contentViewHeight)
        
        constraintViewContent.constant = maxHeight
        
    }
    
    func setConstraintView1() {
        btnValueNext.isHidden = false
        
        constraintViewContent.constant = CGFloat(heightContentView)
        constraintViewValueDetail.constant = CGFloat(heightValueDetail)
        
        constraintViewWhen.constant = 0
        constraintViewWhenDetail.constant = 0
        constraintViewDate.constant = 0
        constraintViewDateDetail.constant = 0
        
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight - 78 - 200
        let contentViewHeight = constraintViewContent.constant - CGFloat(
            heightWhenView +
                heightWhenDetail +
                heightDateView +
            heightDateDetail)
        let maxHeight = max(height, contentViewHeight)
        
        constraintViewContent.constant = maxHeight
    }
    
    func setConstraintView2() {
        btnValueNext.isHidden = true
        
        constraintViewContent.constant = CGFloat(heightContentView)
        constraintViewValue.constant = CGFloat(heightValueView)
        constraintViewWhenDetail.constant = CGFloat(heightWhenDetail)
        constraintViewDate.constant = CGFloat(heightDateView)
        
        constraintViewValueDetail.constant = 0
        constraintViewWhen.constant = 0
        constraintViewDateDetail.constant = 0
        
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight - 78 - 200
        let contentViewHeight = constraintViewContent.constant - CGFloat(
            heightValueDetail +
                heightWhenView +
            heightDateDetail
        )
        let maxHeight = max(height, contentViewHeight)
        
        constraintViewContent.constant = maxHeight
    }
    
    func setConstraintView3() {
        btnValueNext.isHidden = true
        
        constraintViewContent.constant = CGFloat(heightContentView)
        constraintViewValue.constant = CGFloat(heightValueView)
        constraintViewWhen.constant = CGFloat(heightWhenView)
        constraintViewDateDetail.constant = CGFloat(heightDateDetail)
        
        constraintViewValueDetail.constant = 0
        constraintViewWhenDetail.constant = 0
        constraintViewDate.constant = 0
        
        let screenHeight = UIScreen.main.bounds.height
        let height = screenHeight - 78 - 200
        let contentViewHeight = constraintViewContent.constant - CGFloat(
            heightValueDetail +
                heightWhenDetail +
            heightDateView
        )
        let maxHeight = max(height, contentViewHeight)
        
        constraintViewContent.constant = maxHeight
        
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setConstraintView1()
    }
    
    @IBAction func tapBtnNext(_ sender: Any) {
        txtValue.resignFirstResponder()
        
        self.setConstraintView0()
    }
    
    @IBAction func tapBtnBgWhenView(_ sender: Any) {
        self.setConstraintView2()
    }
    
    @IBAction func tapBtnAM(_ sender: Any) {
        index3 = 0
        self.setTimeTitle(idx1: index1, idx2: index2, idx3: index3)
    }
    
    @IBAction func tapBtnPM(_ sender: Any) {
        index3 = 1
        self.setTimeTitle(idx1: index1, idx2: index2, idx3: index3)
    }
    
    @IBAction func tapBtnSelectHour(_ sender: Any) {
        index1 = (sender as AnyObject).tag
        self.setTimeTitle(idx1: index1, idx2: index2, idx3: index3)
    }
    
    @IBAction func tapBtnSelectMinute(_ sender: Any) {
        index2 = (sender as AnyObject).tag
        self.setTimeTitle(idx1: index1, idx2: index2, idx3: index3)
    }
    
    @IBAction func tapBtnBgDateView(_ sender: Any) {
        self.setConstraintView3()
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        if (txtValue.text?.count)! > 0 {
            print(">>>> sendDate        :", sendDate)
            print(">>>> value           :", txtValue.text!)
            
            self.delegate?.didTapButtonAddManuallyHemoglobinA1cViewController(date: sendDate,
                                                                              time: sendTime,
                                                                              timeIndex: sendTimeIndex,
                                                                              value: txtValue.text as! String
            )
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    // MARK - FSCalendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // selection color
        if date != Date() {
            calendar.appearance.titleTodayColor = UIColor.black
        }
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.selectionColor = UIColor.init(hexString: "39D3E3")

        let strSendDate = dateFormatter.string(from: date)
        print(">>>> strdate:", strSendDate)
        
        lblDate.text = dateFormatter.string(from: date)
        sendDate = date
        
        self.setConstraintView0()
    }
    
    
}
