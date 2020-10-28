//
//  PopupBloodGlucoseViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

protocol PopupBloodGlucoseViewControllerDelegate: class {
    func didTapButtonClosePopupBloodGlucoseViewController()
    func didTapButtonErrorPopupBloodGlucoseViewController(error: String)
    func didTapButtonDonePopupBloodGlucoseViewController(date: Date, whenIndex: String, value: NSInteger)
}

class PopupBloodGlucoseViewController: UIViewController, PopupCalenderViewControllerDelegate {

    weak var delegate:PopupBloodGlucoseViewControllerDelegate?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subViewDate: UIView!
    @IBOutlet weak var subViewWhen: UIView!
    @IBOutlet weak var bgWhenView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitleWhen: UILabel!
    
    @IBOutlet weak var lblTitleWhen2: UILabel!
    @IBOutlet weak var lblWhen: UILabel!
    
    @IBOutlet weak var lblTitleEnter: UILabel!
    @IBOutlet weak var lblTitleUnit: UILabel!
    @IBOutlet weak var txtLevel: UITextField!
    
    @IBOutlet weak var btnBgDate: UIButton!
    @IBOutlet weak var btnBgWhen: UIButton!
    @IBOutlet weak var btnBefore: UIButton!
    @IBOutlet weak var btnAfter: UIButton!
    @IBOutlet weak var btnBreakfast: UIButton!
    @IBOutlet weak var btnLunch: UIButton!
    @IBOutlet weak var btnDinner: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    var popupCalenderViewController = PopupCalenderViewController()
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
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true;
        
        subViewDate.layer.cornerRadius = 10
        subViewDate.layer.masksToBounds = true;
        
        subViewWhen.layer.cornerRadius = 10
        subViewWhen.layer.masksToBounds = true;
        
        txtLevel.layer.cornerRadius = 10
        txtLevel.layer.masksToBounds = true;
        txtLevel.layer.borderWidth = 0.8
        txtLevel.layer.borderColor = UIColor.lightGray.cgColor
        
        txtLevel.keyboardType = .numberPad
        
        btnBefore.layer.cornerRadius = 10
        btnBefore.layer.masksToBounds = true;
        
        btnAfter.layer.cornerRadius = 10
        btnAfter.layer.masksToBounds = true;
        
        btnBreakfast.layer.cornerRadius = 10
        btnBreakfast.layer.masksToBounds = true;
        
        btnLunch.layer.cornerRadius = 10
        btnLunch.layer.masksToBounds = true;
        
        btnDinner.layer.cornerRadius = 10
        btnDinner.layer.masksToBounds = true;
        
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true;
        
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true;

        btnDone.layer.cornerRadius = 10
        btnDone.layer.masksToBounds = true;
     
        bgWhenView.isHidden = false
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        arrayWhen1 = ["Before", "After"]
        arrayWhen2 = ["Breakfast", "Lunch", "Dinner"]

        bgWhenView.isHidden = !isNew
        btnBgDate.isEnabled = isNew
        btnBgWhen.isEnabled = isNew

        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleWhen.font = UIFont.init(name: "Montserrat", size: 20)
        lblWhen.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleEnter.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleUnit.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitle.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleWhen2.font = UIFont.init(name: "Montserrat", size: 20)


        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnCancel.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnBefore.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnAfter.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnBreakfast.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnLunch.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnDinner.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnOK.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)

    }
    
    func setSelfData() {
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
    
    @IBAction func tapBtnOK(_ sender: Any) {
        bgWhenView.isHidden = true
        lblWhen.text =  String(format: "%@ %@", arrayWhen1[index1] as! String, arrayWhen2[index2] as! String)
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupBloodGlucoseViewController()
    }

    @IBAction func tapBtnBgDate(_ sender: Any) {
        self.loadPopupCalendarViewController()
        
    }

    // MARK - load PopupCalendarViewController
    func loadPopupCalendarViewController() {
        sleep(UInt32(0.5))
        
        popupCalenderViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupCalenderViewController") as? PopupCalenderViewController)!
        popupCalenderViewController.delegate = self
        popupCalenderViewController.index = 0
        
        UIApplication.shared.keyWindow?.addSubview((popupCalenderViewController.view)!)
    }
    
    // MARK - PopupcalendarViewController delegate
    func didTapButtonClosePopupCalenderViewController() {
        popupCalenderViewController.view.removeFromSuperview()
    }
    
    func didTapButtonChooseDatePopupCalenderViewController(date: Date) {
        popupCalenderViewController.view.removeFromSuperview()
        
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
        print(">>> date:", strDate)
        sendDate = date
    }
    
    @IBAction func tapBtnBgWhen(_ sender: Any) {
        bgWhenView.isHidden = false
    }
    
    @IBAction func tapBtnCancel(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupBloodGlucoseViewController()
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        if (txtLevel.text?.count)! > 0 {
            self.delegate?.didTapButtonDonePopupBloodGlucoseViewController(date: sendDate,
                                                                           whenIndex: sendWhenIndex,
                                                                           value: NSInteger(txtLevel.text!)!)
        } else { 
            self.delegate?.didTapButtonErrorPopupBloodGlucoseViewController(error: "Please input the level.")
        }
    }
    
}
