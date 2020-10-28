//
//  VerifyInformationBloodPressureViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/07/05.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit

class VerifyInformationBloodPressureViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var txtValue1: UITextField!
    @IBOutlet weak var txtValue2: UITextField!
    @IBOutlet weak var lblUnit: UILabel!
    
    @IBOutlet weak var bgViewValue1: UIView!
    @IBOutlet weak var bgViewValue2: UIView!
    @IBOutlet weak var bgViewUnit: UIView!
    
    @IBOutlet weak var lblTitleWhen: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var bgViewWhen: UIView!
    @IBOutlet weak var bgViewDate: UIView!
    
    @IBOutlet weak var btnDone: UIButton!
    
    var dateFormatter = DateFormatter()
    
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
        // font
        lblTitle.font = UIFont.init(name: "Montserrat", size: 38)
        lblSubTitle.font = UIFont.init(name: "Montserrat", size: 20)
        txtValue1.font = UIFont.init(name: "Montserrat", size: 20)
        txtValue2.font = UIFont.init(name: "Montserrat", size: 20)
        lblUnit.font = UIFont.init(name: "Montserrat", size: 20)
        
        lblTitleWhen.font = UIFont.init(name: "Montserrat", size: 20)
        lblTime.font = UIFont.init(name: "Montserrat", size: 17)
        
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 17)
        
        
        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        
        // keyboard type
        txtValue1.keyboardType = .numberPad
        txtValue2.keyboardType = .numberPad
        txtValue1.delegate = self
        txtValue2.delegate = self
        
        txtValue1.isUserInteractionEnabled = false
        txtValue2.isUserInteractionEnabled = false
        
        // round view
        bgViewValue1.layer.cornerRadius = 8
        bgViewValue1.layer.masksToBounds = true;
        bgViewValue2.layer.cornerRadius = 8
        bgViewValue2.layer.masksToBounds = true;
        
        bgViewUnit.layer.cornerRadius = 8
        bgViewUnit.layer.masksToBounds = true;
        
        bgViewWhen.layer.cornerRadius = 8
        bgViewWhen.layer.masksToBounds = true;
        
        bgViewDate.layer.cornerRadius = 8
        bgViewDate.layer.masksToBounds = true;

        btnDone.layer.cornerRadius = 8
        btnDone.layer.masksToBounds = true;
        
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
    }
    
    func setSelfData() {
        let date = Date()
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
//        sendDate = date
//        
//        sendTimeIndex = "0"
//        index1 = 0
//        index2 = 0
//        index3 = 0
//        self.setTimeTitle(idx1: index1, idx2: index2, idx3: index3)
        
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
