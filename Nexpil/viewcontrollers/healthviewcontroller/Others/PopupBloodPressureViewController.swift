//
//  PopupBloodPressureViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

protocol PopupBloodPressureViewControllerDelegate: class {
    func didTapButtonClosePopupBloodPressureViewController()
    func didTapButtonDonePopupBloodPressureViewController(date: Date,
                                                          time: String,
                                                          timeIndex: String,
                                                          pressure1: String,
                                                          pressure2: String)

}

class PopupBloodPressureViewController: UIViewController,
PopupCalenderViewControllerDelegate {

    weak var delegate:PopupBloodPressureViewControllerDelegate?

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subViewDate: UIView!
    @IBOutlet weak var subViewTime: UIView!
    @IBOutlet weak var bgTimeView: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitleTime: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitleEnter: UILabel!
    @IBOutlet weak var lblSelectTime: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var lblTitleTime2: UILabel!
    @IBOutlet weak var lblTitleSub1: UILabel!
    @IBOutlet weak var lblTitleSub2: UILabel!
    
    @IBOutlet weak var txtSYS: UITextField!
    @IBOutlet weak var txtDIA: UITextField!
    
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

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAM: UIButton!
    @IBOutlet weak var btnPM: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    var popupCalenderViewController = PopupCalenderViewController()
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
        
        subViewTime.layer.cornerRadius = 10
        subViewTime.layer.masksToBounds = true;
        
        txtSYS.layer.cornerRadius = 10
        txtSYS.layer.masksToBounds = true;
        txtSYS.layer.borderWidth = 0.8
        txtSYS.layer.borderColor = UIColor.lightGray.cgColor
        
        txtSYS.keyboardType = .numberPad
        
        txtDIA.layer.cornerRadius = 10
        txtDIA.layer.masksToBounds = true;
        txtDIA.layer.borderWidth = 0.8
        txtDIA.layer.borderColor = UIColor.lightGray.cgColor
        
        txtDIA.keyboardType = .numberPad
        
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
        
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true;
        
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true;
        
        btnDone.layer.cornerRadius = 10
        btnDone.layer.masksToBounds = true;
        
        bgTimeView.isHidden = false
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
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

        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleTime.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleTime2.font = UIFont.init(name: "Montserrat", size: 20)
        lblTime.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleEnter.font = UIFont.init(name: "Montserrat", size: 20)
        lblUnit.font = UIFont.init(name: "Montserrat", size: 20)
        lblSelectTime.font = UIFont.init(name: "Montserrat", size: 30)
        
        lblTitleSub1.font = UIFont.init(name: "Montserrat", size: 12)
        lblTitleSub2.font = UIFont.init(name: "Montserrat", size: 12)

        
        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnCancel.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnAM.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnPM.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnOK.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)

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
        let strColorPurple = "4939e3"
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
        lblSelectTime.text = arrayTime1[index1] + ":" + arrayTime2[index2]
        
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
    
    @IBAction func tapBtnBgDate(_ sender: Any) {
        self.loadPopupCalendarViewController()
    }
    
    // MARK - load PopupCalendarViewController
    func loadPopupCalendarViewController() {
        sleep(UInt32(0.5))
        
        popupCalenderViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupCalenderViewController") as? PopupCalenderViewController)!
        popupCalenderViewController.delegate = self
        popupCalenderViewController.index = 1
        
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
    
    @IBAction func tapBtnBgTime(_ sender: Any) {
        bgTimeView.isHidden = false
    }
    
    @IBAction func tapBtnAM(_ sender: Any) {
        index3 = 0
        self.setTimeTitle(idx1: index1, idx2: index2, idx3: index3)
    }
    
    @IBAction func tapBtnMP(_ sender: Any) {
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
    
    @IBAction func tapBtnOK(_ sender: Any) {
        bgTimeView.isHidden = true
        lblTime.text = sendTime
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupBloodPressureViewController()
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        self.delegate?.didTapButtonDonePopupBloodPressureViewController(date: sendDate,
                                                                        time: sendTime,
                                                                        timeIndex: sendTimeIndex,
                                                                        pressure1: txtSYS.text as! String,
                                                                        pressure2: txtDIA.text as! String)
    }
    
    @IBAction func tapBtnCancel(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupBloodPressureViewController()
    }
    
    
}
