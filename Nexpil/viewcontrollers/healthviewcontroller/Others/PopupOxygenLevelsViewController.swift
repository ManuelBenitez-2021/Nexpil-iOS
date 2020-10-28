//
//  PopupOxygenLevelsViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/06/01.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

protocol PopupOxygenLevelsViewControllerDelegate: class {
    func didTapButtonClosePopupOxygenLevelsViewControllerDelegate()
    func didTapButtonDonePopupOxygenLevelsViewControllerDelegate(date: Date,
                                                          time: String,
                                                          level: String)
    
}

class PopupOxygenLevelsViewController: UIViewController, PopupCalenderViewControllerDelegate {

    weak var delegate:PopupOxygenLevelsViewControllerDelegate?
    
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
    @IBOutlet weak var lblTitleTime2: UILabel!
    
    @IBOutlet weak var txtLevel: UITextField!
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnTime1: UIButton!
    @IBOutlet weak var btnTime2: UIButton!
    @IBOutlet weak var btnTime3: UIButton!
    
    var popupCalenderViewController = PopupCalenderViewController()
    var dateFormatter = DateFormatter()
    var sendDate = Date()
    var sendTime = String()
    
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
        
        txtLevel.layer.cornerRadius = 10
        txtLevel.layer.masksToBounds = true;
        txtLevel.layer.borderWidth = 0.8
        txtLevel.layer.borderColor = UIColor.lightGray.cgColor
        
        txtLevel.keyboardType = .numberPad
        
        btnTime1.layer.cornerRadius = 10
        btnTime1.layer.masksToBounds = true;
        
        btnTime2.layer.cornerRadius = 10
        btnTime2.layer.masksToBounds = true;
        
        btnTime3.layer.cornerRadius = 10
        btnTime3.layer.masksToBounds = true;
        
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true;
        
        btnDone.layer.cornerRadius = 10
        btnDone.layer.masksToBounds = true;
        
        setTimeButton(index: 1)
        bgTimeView.isHidden = false
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleTime.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleTime2.font = UIFont.init(name: "Montserrat", size: 20)
        lblTime.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleEnter.font = UIFont.init(name: "Montserrat", size: 20)

        
        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnCancel.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnTime1.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnTime2.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnTime3.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
    }
    
    func setSelfData() {
        let date = Date()
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
        sendDate = date
        
    }

    @IBAction func tapBtnBgDate(_ sender: Any) {
        self.loadPopupCalendarViewController()
    }
    
    // MARK - load PopupCalendarViewController
    func loadPopupCalendarViewController() {
        sleep(UInt32(0.5))
        
        popupCalenderViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupCalenderViewController") as? PopupCalenderViewController)!
        popupCalenderViewController.delegate = self
        popupCalenderViewController.index = 2
        
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
    
    @IBAction func tapBtnTime1(_ sender: Any) {
        self.setTimeButton(index: 1)
    }
    
    @IBAction func tapBtnTime2(_ sender: Any) {
        self.setTimeButton(index: 2)
    }
    
    @IBAction func tapBtnTime3(_ sender: Any) {
        self.setTimeButton(index: 3)
    }
    
    func setTimeButton(index: NSInteger) {
        let strColorCyan = "39D3E3"
        let strColorWhite = "FFFFFF"
        let strColorLightGray = "EBEBF1"
        let strColorGray = "333333"

        btnTime1.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnTime1.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnTime2.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnTime2.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)
        btnTime3.backgroundColor = UIColor.init(hexString: strColorLightGray)
        btnTime3.setTitleColor(UIColor.init(hexString: strColorGray), for: .normal)

        if index == 1 {
            btnTime1.backgroundColor = UIColor.init(hexString: strColorCyan)
            btnTime1.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
        
            sendTime = "8:00am"
        } else if index == 2 {
            btnTime2.backgroundColor = UIColor.init(hexString: strColorCyan)
            btnTime2.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            sendTime = "2:00pm"
        } else if index == 3 {
            btnTime3.backgroundColor = UIColor.init(hexString: strColorCyan)
            btnTime3.setTitleColor(UIColor.init(hexString: strColorWhite), for: .normal)
            
            sendTime = "8:00pm"

        }
        
        lblTime.text = sendTime
        bgTimeView.isHidden = true
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupOxygenLevelsViewControllerDelegate()
    }
    
    @IBAction func tapBtnCancel(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupOxygenLevelsViewControllerDelegate()
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        print(">>> date:", sender)
        print(">>> sendTime:", sendTime)
        print(">>> level:", txtLevel.text)
        
        self.delegate?.didTapButtonDonePopupOxygenLevelsViewControllerDelegate(date: sendDate,
                                                                               time: sendTime,
                                                                               level: txtLevel.text as! String)
    }
}
