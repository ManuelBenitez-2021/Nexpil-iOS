//
//  VerifyInformationBloodGlucoseViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/07/05.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

class VerifyInformationBloodGlucoseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var bgViewValue: UIView!
    @IBOutlet weak var bgViewUnit: UIView!
    
    @IBOutlet weak var bgViewWhen: UIView!
    @IBOutlet weak var lblTitleWhen: UILabel!
    @IBOutlet weak var lblWhen: UILabel!
    
    @IBOutlet weak var bgViewDate: UIView!
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    
    var dateFormatter = DateFormatter()
    var sendDate = Date()
    var sendWhenIndex = String()
    var index1 = NSInteger()
    var index2 = NSInteger()
    var arrayWhen1 = NSArray()
    var arrayWhen2 = NSArray()
    var isNew = Bool()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
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
        // font
        lblTitle.font = UIFont.init(name: "Montserrat", size: 38)
        lblSubTitle.font = UIFont.init(name: "Montserrat", size: 20)
        txtValue.font = UIFont.init(name: "Montserrat", size: 20)
        lblUnit.font = UIFont.init(name: "Montserrat", size: 20)
        
        lblTitleWhen.font = UIFont.init(name: "Montserrat", size: 20)
        lblWhen.font = UIFont.init(name: "Montserrat", size: 17)
        
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 17)
        
        
        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        // keyboard type
        txtValue.keyboardType = .numberPad
        txtValue.delegate = self
        
        txtValue.isUserInteractionEnabled = false
        
        // round view
        bgViewValue.layer.cornerRadius = 8
        bgViewValue.layer.masksToBounds = true;
        
        bgViewUnit.layer.cornerRadius = 8
        bgViewUnit.layer.masksToBounds = true;
        
        bgViewWhen.layer.cornerRadius = 8
        bgViewWhen.layer.masksToBounds = true;
        
        bgViewDate.layer.cornerRadius = 8
        bgViewDate.layer.masksToBounds = true;
        
        btnDone.layer.cornerRadius = 8
        btnDone.layer.masksToBounds = true;
        
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        arrayWhen1 = ["Before", "After"]
        arrayWhen2 = ["Breakfast", "Lunch", "Dinner"]
        
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
            /*
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
            */
        }
        
        self.setWhenTitle(idx1: index1, idx2: index2)
        
        // date
        sendDate = Date()
        lblDate.text = dateFormatter.string(from: Date())
    }

    func setWhenTitle(idx1: NSInteger, idx2: NSInteger) {
//        let strColorLightGray = "EBEBF1"
//        let strColorBule = "397EE3"
//        let strColorGray = "333333"
//        let strColorWhite = "FFFFFF"
        
        /*
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
        */
        
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
    

    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
