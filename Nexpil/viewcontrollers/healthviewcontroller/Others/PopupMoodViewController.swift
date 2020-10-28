//
//  PopupMoodViewController.swift
//  Nexpil
//
//  Created by Loyal Lauzier on 2018/05/31.
//  Copyright © 2018 MobileDev. All rights reserved.
//

import UIKit
import StepSlider

protocol PopupMoodViewControllerDelegate: class {
    func didTapButtonClosePopupMoodViewController()
    func didTapButtonDonePopupMoodViewController(date: Date, feeling: NSInteger, notes: String)
}

class PopupMoodViewController: UIViewController,
    PopupCalenderViewControllerDelegate
{

    weak var delegate:PopupMoodViewControllerDelegate?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subViewDate: UIView!
    @IBOutlet weak var subViewFeeling: UIView!
    @IBOutlet weak var bgFeelingView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTitleDate: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitleFeeling: UILabel!
    @IBOutlet weak var lblFeeling: UILabel!
    @IBOutlet weak var lblTitleNote: UILabel!
    @IBOutlet weak var lblTitlehowTo: UILabel!
    
    @IBOutlet weak var lblChooseFeeling: UILabel!
    @IBOutlet weak var txtNotes: UITextField!
    @IBOutlet weak var imgfeeling: UIImageView!
    @IBOutlet weak var slider: StepSlider!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    var popupCalenderViewController = PopupCalenderViewController()
    var dateFormatter = DateFormatter()
    var sendDate = Date()
    var sendFeeling = NSInteger()
    var sendNotes = String()
    
    var index = NSInteger()
    var dicMood = Mood()
    var isNew = Bool()
    var isEdit = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.initMainView()
        
        if isNew == true {
            self.setSelfData()
        } else {
            self.setData()
        }
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
        
        subViewFeeling.layer.cornerRadius = 10
        subViewFeeling.layer.masksToBounds = true;

        txtNotes.layer.cornerRadius = 10
        txtNotes.layer.masksToBounds = true;
        txtNotes.layer.masksToBounds = true;
        
        btnCancel.layer.cornerRadius = 10
        btnCancel.layer.masksToBounds = true;
        
        btnDone.layer.cornerRadius = 10
        btnDone.layer.masksToBounds = true;
        
        btnOK.layer.cornerRadius = 10
        btnOK.layer.masksToBounds = true;
        
        txtNotes.layer.borderColor = UIColor.lightGray.cgColor
        txtNotes.layer.borderWidth = 0.8

        txtNotes.text = ""
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        bgFeelingView.isHidden = false
        
        lblTitle.font = UIFont.init(name: "Montserrat", size: 30)
        lblTitleDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblDate.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleFeeling.font = UIFont.init(name: "Montserrat", size: 20)
        lblFeeling.font = UIFont.init(name: "Montserrat", size: 20)
        lblTitleNote.font = UIFont.init(name: "Montserrat", size: 24)

        btnDone.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnCancel.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)
        btnOK.titleLabel?.font = UIFont.init(name: "Montserrat", size: 20)

        lblTitlehowTo.font = UIFont.init(name: "Montserrat", size: 20)
        lblChooseFeeling.font = UIFont.init(name: "Montserrat", size: 20)

    }
    
    func setSelfData() {
        let date = Date()
        let strDate = dateFormatter.string(from: date)
        lblDate.text = strDate
        sendDate = date

        self.setFeelingVew(idx: 2)
        
    }
    
    func setData() {
        if isNew != true {
            let date = dicMood.date! as Date
            let notes = dicMood.notes
            let idx = dicMood.feeling
            
            let strDate = dateFormatter.string(from: date)
            lblDate.text = strDate
            sendDate = date
            
            if (notes?.count)! > 0 {
                txtNotes.text = notes
            }
            
            self.setFeelingVew(idx: NSInteger(idx))
            
            if isEdit == true {
                bgFeelingView.isHidden = true
            }
        }
    }
    
    func setFeelingVew(idx: NSInteger) {
        let arrayFeeling = [
            ["index": "0", "imageName": "feel_0", "title": "Very Sad"],
            ["index": "1", "imageName": "feel_1", "title": "Sad"],
            ["index": "2", "imageName": "feel_2", "title": "Neutral"],
            ["index": "3", "imageName": "feel_3", "title": "Happy"],
            ["index": "4", "imageName": "feel_4", "title": "Very Happy"],
            ]
        let imageName = arrayFeeling[idx]["imageName"]
        let title = arrayFeeling[idx]["title"]
        
        imgfeeling.image = UIImage.init(named: imageName!)
        lblChooseFeeling.text = title
        lblFeeling.text = title
        
        sendFeeling = idx
        
        if isNew == true {
            // 2
//            slider.index =  UInt(2)
        } else {
            // idx
            slider.index = UInt(idx)
        }
        
    }
    
    @IBAction func tapBtnClose(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupMoodViewController()
    }
    
    @IBAction func tapBtnBgDate(_ sender: Any) {
        self.loadPopupCalendarViewController()
    }
    
    // MARK - load PopupCalendarViewController
    func loadPopupCalendarViewController() {
        sleep(UInt32(0.5))
        
        popupCalenderViewController = (self.storyboard?.instantiateViewController(withIdentifier: "PopupCalenderViewController") as? PopupCalenderViewController)!
        popupCalenderViewController.delegate = self
        popupCalenderViewController.index = 3
        
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
    
    @IBAction func tapBtnBgFeeling(_ sender: Any) {
        bgFeelingView.isHidden = false
    }
    
    @IBAction func changeValue(_ sender: StepSlider) {
        let index = sender.index

        self.setFeelingVew(idx: NSInteger(index))
    }
    
    @IBAction func tapBtnChooseFeelingOK(_ sender: Any) {
        bgFeelingView.isHidden = true
        
    }
    
    @IBAction func tapBtnCancel(_ sender: Any) {
        self.delegate?.didTapButtonClosePopupMoodViewController()
    }
    
    @IBAction func tapBtnDone(_ sender: Any) {
        self.delegate?.didTapButtonDonePopupMoodViewController(date: sendDate,
                                                               feeling: sendFeeling,
                                                               notes: txtNotes.text as! String)
    }
    
}
