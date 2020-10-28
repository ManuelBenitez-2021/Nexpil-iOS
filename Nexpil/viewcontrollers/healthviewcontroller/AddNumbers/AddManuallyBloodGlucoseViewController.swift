//
//  AddManuallyBloodGlucoseViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/07/04.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import FSCalendar

protocol AddManuallyBloodGlucoseViewControllerDelegate: class {
    func didTapButtonDoneAddManuallyBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger)
}


class AddManuallyBloodGlucoseViewController: UIViewController,
UITextFieldDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    weak var delegate:AddManuallyBloodGlucoseViewControllerDelegate?
    
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
    @IBOutlet weak var btnValueDone: UIButton!
    
    @IBOutlet weak var bgViewWhen: UIView!
    @IBOutlet weak var lblTitleWhen: UILabel!
    @IBOutlet weak var lblWhen: UILabel!
    
    @IBOutlet weak var bgViewDate: UIView!
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var lblTitleViewWhenDetail: UILabel!
    @IBOutlet weak var btnBefore: UIButton!
    @IBOutlet weak var btnAfter: UIButton!
    @IBOutlet weak var btnBreakfast: UIButton!
    @IBOutlet weak var btnLunch: UIButton!
    @IBOutlet weak var btnDinner: UIButton!
    
    
    @IBOutlet weak var calendar: FSCalendar!
    
    
    var heightValueView = Float()
    var heightValueDetail = Float()
    var heightWhenView = Float()
    var heightWhenDetail = Float()
    var heightDateView = Float()
    var heightDateDetail = Float()
    var heightContentView = Float()
    
    var dateFormatter = DateFormatter()
    var sendDate = Date()
    var sendWhenIndex = String()
    var index1 = NSInteger()
    var index2 = NSInteger()
    var arrayWhen1 = NSArray()
    var arrayWhen2 = NSArray()
    var isNew = Bool()
    var index = NSInteger()
    var sendDic = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        self.setConstraintView0()
        self.setSelfWhenData()
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
        btnValueDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        lblTitleWhen.font = UIFont.init(name: "Montserrat", size: 20)
        lblWhen.font = UIFont.init(name: "Montserrat", size: 17)
        
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 17)
        
        
        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        lblTitleViewWhenDetail.font = UIFont.init(name: "Montserrat", size: 17)
        
        btnBefore.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnAfter.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnBreakfast.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnLunch.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnDinner.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        // keyboard type
        txtValue.keyboardType = .numberPad
        txtValue.delegate = self
        
        // round view
        bgViewValue.layer.cornerRadius = 8
        bgViewValue.layer.masksToBounds = true;
        
        bgViewUnit.layer.cornerRadius = 8
        bgViewUnit.layer.masksToBounds = true;
        
        btnValueDone.layer.cornerRadius = 8
        btnValueDone.layer.masksToBounds = true;

        bgViewWhen.layer.cornerRadius = 8
        bgViewWhen.layer.masksToBounds = true;
        
        viewWhenDetail.layer.cornerRadius = 8
        viewWhenDetail.layer.masksToBounds = true;
        
        bgViewDate.layer.cornerRadius = 8
        bgViewDate.layer.masksToBounds = true;
        
        viewDateDetail.layer.cornerRadius = 8
        viewDateDetail.layer.masksToBounds = true;
        
        btnDone.layer.cornerRadius = 8
        btnDone.layer.masksToBounds = true;

        btnBefore.layer.cornerRadius = 8
        btnBefore.layer.masksToBounds = true;
        
        btnAfter.layer.cornerRadius = 8
        btnAfter.layer.masksToBounds = true;
        
        btnBreakfast.layer.cornerRadius = 8
        btnBreakfast.layer.masksToBounds = true;
        
        btnLunch.layer.cornerRadius = 8
        btnLunch.layer.masksToBounds = true;
        
        btnDinner.layer.cornerRadius = 8
        btnDinner.layer.masksToBounds = true;
        
        // calendar
        calendar.delegate = self
        calendar.dataSource = self
        calendar.locale = NSLocale.init(localeIdentifier: "en") as Locale

        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        arrayWhen1 = ["Before", "After"]
        arrayWhen2 = ["Breakfast", "Lunch", "Dinner"]
        
        calendar.appearance.headerTitleFont = UIFont.init(name: "Montserrat", size: 24)
        calendar.appearance.weekdayFont = UIFont.init(name: "Montserrat", size: 12)
        calendar.appearance.headerTitleColor = UIColor.black
        
        calendar.appearance.weekdayTextColor = UIColor.init(hexString: "4939E3")
        calendar.appearance.todayColor = UIColor.init(hexString: "397EE3")
        calendar.appearance.selectionColor = UIColor.clear

    }
    
    func setConstraintView0() {
        btnValueDone.isHidden = true

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
        btnValueDone.isHidden = false
        
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
        btnValueDone.isHidden = true
        
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
        btnValueDone.isHidden = true
        
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
        if textField.isEqual(txtValue) {
            self.setConstraintView1()
        }
    }
    
    @IBAction func tapBtnValueDone(_ sender: Any) {
        txtValue.resignFirstResponder()
        self.setConstraintView0()
    }
    
    @IBAction func tapBtnBgWhenView(_ sender: Any) {
        self.setConstraintView2()
    }
    
    @IBAction func tapBtnBgDateView(_ sender: Any) {
        self.setConstraintView3()
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        if (txtValue.text?.count)! > 0 {
            print(">>>> sendDate        :", sendDate)
            print(">>>> sendWhenIndex   :", sendWhenIndex)
            print(">>>> value           :", txtValue.text!)

            self.delegate?.didTapButtonDoneAddManuallyBloodGlucoseViewController(date: sendDate,
                                                                                 whenIndex: sendWhenIndex,
                                                                                 value: NSInteger(txtValue.text!)!)
            
            
            self.dismiss(animated: true, completion: nil)

        }
    }
    
    // when
    func setSelfWhenData() {
        let date = Date()
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
        sendDate = date
        
        if isNew == true {
            index1 = 0
            index2 = 0
            
        } else {
            if index == 0 {
                index1 = 0
                index2 = 0
            }
            
            if index == 1 {
                index1 = 0
                index2 = 1
            }
            
            if index == 2 {
                index1 = 0
                index2 = 2
            }
            
            if index == 3 {
                index1 = 1
                index2 = 0
            }
            
            if index == 4 {
                index1 = 1
                index2 = 1
            }
            
            if index == 5 {
                index1 = 1
                index2 = 2
            }
            
            // set date
            print(">>>> Index:", index)
            print(">>>> Index1:", index1)
            print(">>>> Index2:", index2)
            print(">>>> sendDic:", sendDic)
            let arrayModel = sendDic["data"] as! NSArray
            let anyModel = arrayModel[0] as! BloodGlucose
            let getDate = anyModel.date! as Date
            
            lblDate.text = dateFormatter.string(from: getDate)
            sendDate = getDate
            sendWhenIndex = String(format: "%li", index)
            lblWhen.text =  String(format: "%@ %@", arrayWhen1[index1] as! String, arrayWhen2[index2] as! String)

        }
        
        self.setWhenTitle(idx1: index1, idx2: index2)
        
        // date
        sendDate = Date()
        lblDate.text = dateFormatter.string(from: Date())
    }

    func setWhenTitle(idx1: NSInteger, idx2: NSInteger) {
        let strColorLightGray = "EBEBF1"
        let strColorBule = "397EE3"
        let strColorGray = "333333"
        let strColorWhite = "FFFFFF"
        
        if idx1 == 0 {
            btnBefore.backgroundColor = UIColor.init(hexString: strColorBule)
            btnBefore.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            btnAfter.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnAfter.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
            
        } else if idx1 == 1 {
            btnAfter.backgroundColor = UIColor.init(hexString: strColorBule)
            btnAfter.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            btnBefore.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnBefore.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        }
        
        if idx2 == 0 {
            btnBreakfast.backgroundColor = UIColor.init(hexString: strColorBule)
            btnBreakfast.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            btnLunch.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnLunch.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
            
            btnDinner.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnDinner.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
            
        } else if idx2 == 1 {
            btnLunch.backgroundColor = UIColor.init(hexString: strColorBule)
            btnLunch.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            btnBreakfast.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnBreakfast.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
            
            btnDinner.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnDinner.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
            
        } else if idx2 == 2 {
            btnDinner.backgroundColor = UIColor.init(hexString: strColorBule)
            btnDinner.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            btnLunch.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnLunch.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
            
            btnBreakfast.backgroundColor = UIColor.init(hexString: strColorLightGray)
            btnBreakfast.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        }
        
        
        if idx1 == 0 {
            if idx2 == 0 {
                sendWhenIndex = "0"
            } else if idx2 == 1 {
                sendWhenIndex = "1"
            } else if idx2 == 2 {
                sendWhenIndex = "2"
            }
        }
        
        if idx1 == 1 {
            if idx2 == 0 {
                sendWhenIndex = "3"
            } else if idx2 == 1 {
                sendWhenIndex = "4"
            } else if idx2 == 2 {
                sendWhenIndex = "5"
            }
        }
        
        /*
         Before  After
         Breakfast     0       3
         Lunch         1       4
         Dinner        2       5
         
         */
     
        lblWhen.text =  String(format: "%@ %@", arrayWhen1[index1] as! String, arrayWhen2[index2] as! String)

    }
    
    @IBAction func tapBtnBefore(_ sender: Any) {
        index1 = 0
        self.setWhenTitle(idx1: index1, idx2: index2)
    }
    
    @IBAction func tapBtnAfter(_ sender: Any) {
        index1 = 1
        self.setWhenTitle(idx1: index1, idx2: index2)
    }
    
    @IBAction func tapBtnBreakfast(_ sender: Any) {
        index2 = 0
        self.setWhenTitle(idx1: index1, idx2: index2)
    }
    
    @IBAction func tapBtnLunch(_ sender: Any) {
        index2 = 1
        self.setWhenTitle(idx1: index1, idx2: index2)
    }
    
    @IBAction func tapBtnDinner(_ sender: Any) {
        index2 = 2
        self.setWhenTitle(idx1: index1, idx2: index2)
    }

    // MARK - FSCalendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        // selection color
        if date != Date() {
            calendar.appearance.titleTodayColor = UIColor.black
        }
        calendar.appearance.todayColor = UIColor.clear
        calendar.appearance.selectionColor = UIColor.init(hexString: "397EE3")
        
        let strSendDate = dateFormatter.string(from: date)
        print(">>>> strdate:", strSendDate)
        
        lblDate.text = dateFormatter.string(from: date)
        sendDate = date

        self.setConstraintView0()
    }
    
    
}
