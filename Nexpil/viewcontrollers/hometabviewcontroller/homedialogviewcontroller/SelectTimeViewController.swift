//
//  SelectTimeViewController.swift
//  Nexpil
//
//  Created by Admin on 4/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SelectTimeViewController: UIViewController {

    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var strength: UILabel!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var quantiyValue: UILabel!
    @IBOutlet weak var painScoreView: UIView!
    @IBOutlet weak var painscoreValue: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    
    var mymedication = MyMedication()
    
    var quantity = ""
    var painScore = ""
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var noonLabel: UILabel!
    @IBOutlet weak var morningView: UIView!
    @IBOutlet weak var noonView: UIView!
    
    var delegate: DialogClose?
    
    @IBOutlet weak var tv1: UIView!
    @IBOutlet weak var tv2: UIView!
    @IBOutlet weak var tv3: UIView!
    @IBOutlet weak var tv4: UIView!
    @IBOutlet weak var tv5: UIView!
    @IBOutlet weak var tv6: UIView!
    @IBOutlet weak var tv7: UIView!
    @IBOutlet weak var tv8: UIView!
    @IBOutlet weak var tv9: UIView!
    @IBOutlet weak var tv10: UIView!
    @IBOutlet weak var tv11: UIView!
    @IBOutlet weak var tv12: UIView!
    
    @IBOutlet weak var tl1: UILabel!
    @IBOutlet weak var tl2: UILabel!
    @IBOutlet weak var tl3: UILabel!
    @IBOutlet weak var tl4: UILabel!
    @IBOutlet weak var tl5: UILabel!
    @IBOutlet weak var tl6: UILabel!
    @IBOutlet weak var tl7: UILabel!
    @IBOutlet weak var tl8: UILabel!
    @IBOutlet weak var tl9: UILabel!
    @IBOutlet weak var tl10: UILabel!
    @IBOutlet weak var tl11: UILabel!
    @IBOutlet weak var tl12: UILabel!
    
    @IBOutlet weak var mv1: UIView!
    @IBOutlet weak var mv2: UIView!
    @IBOutlet weak var mv3: UIView!
    @IBOutlet weak var mv4: UIView!
    @IBOutlet weak var mv5: UIView!
    @IBOutlet weak var mv6: UIView!
    @IBOutlet weak var mv7: UIView!
    @IBOutlet weak var mv8: UIView!
    @IBOutlet weak var mv9: UIView!
    @IBOutlet weak var mv10: UIView!
    @IBOutlet weak var mv11: UIView!
    @IBOutlet weak var mv12: UIView!
    
    @IBOutlet weak var ml1: UILabel!
    @IBOutlet weak var ml2: UILabel!
    @IBOutlet weak var ml3: UILabel!
    @IBOutlet weak var ml4: UILabel!
    @IBOutlet weak var ml5: UILabel!
    @IBOutlet weak var ml6: UILabel!
    @IBOutlet weak var ml7: UILabel!
    @IBOutlet weak var ml8: UILabel!
    @IBOutlet weak var ml9: UILabel!
    @IBOutlet weak var ml10: UILabel!
    @IBOutlet weak var ml11: UILabel!
    @IBOutlet weak var ml12: UILabel!
    
    var tvs:[UIView]?
    var tls:[UILabel]?
    var mvs:[UIView]?
    var mls:[UILabel]?
    
    var mns:[UIView]?
    var mnls:[UILabel]?
    var selectedTime = 8
    var selectedMinute = 0
    
    var selectedMorningnoon = 0
    
    var timeRange = ""
    var colorCode = ""
    var dayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        quantityView.layer.cornerRadius = 10
        painScoreView.layer.cornerRadius = 10
        timeView.viewShadow()
        mainView.viewShadow()
        
        morningLabel.text = "AM"
        noonLabel.text = "PM"
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect(sender:)))
        quantityView.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect1(sender:)))
        painScoreView.addGestureRecognizer(gesture1)
        
        tvs = [tv1,tv2,tv3,tv4,tv5,tv6,tv7,tv8,tv9,tv10,tv11,tv12]
        tls = [tl1,tl2,tl3,tl4,tl5,tl6,tl7,tl8,tl9,tl10,tl11,tl12]
        mvs = [mv1,mv2,mv3,mv4,mv5,mv6,mv7,mv8,mv9,mv10,mv11,mv12]
        mls = [ml1,ml2,ml3,ml4,ml5,ml6,ml7,ml8,ml9,ml10,ml11,ml12]
        
        mns = [morningView,noonView]
        mnls = [morningLabel,noonLabel]
        for index in 0 ..< tvs!.count
        {
            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(timeSelect(sender:)))
            tvs![index].tag = index
            tvs![index].layer.cornerRadius = 10
            
            tvs![index].addGestureRecognizer(gesture2)
            
            let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(minuteSelect(sender:)))
            mvs![index].tag = index
            mvs![index].layer.cornerRadius = 10
            mvs![index].addGestureRecognizer(gesture3)
        }
        
        for index in 0 ..< mns!.count
        {
            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(morningnoonSelect(sender:)))
            mns![index].tag = index
            mns![index].layer.cornerRadius = mns![index].frame.size.height/2
            mns![index].addGestureRecognizer(gesture2)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        medicationname.text = mymedication.medicationname
        strength.text = mymedication.strength
        quantiyValue.text = quantity
        painscoreValue.text = painScore + " - Severse Pain"
        
        let taketime = mymedication.createat.components(separatedBy: " ")[1]
        let hour = taketime.components(separatedBy: ":")[0]
        let min = taketime.components(separatedBy: ":")[1]
        
        if mymedication.taketime == "Morning"
        {
            colorCode = "39d3e3"
            dayIndex = 0
        }
        if mymedication.taketime == "Midday"
        {
            colorCode = "397EE3"
            dayIndex = 1
        }
        if mymedication.taketime == "Evening"
        {
            colorCode = "415CE3"
            dayIndex = 2
        }
        if mymedication.taketime == "Night"
        {
            colorCode = "4939E3"
            dayIndex = 3
        }
        timeInitialize(hour: hour, min: min)
        
        /*
        if mymedication.taketime == "Morning"
        {
            timeLabel.text = tls![8].text! + ":" + mls![0].text!
            morningView.layer.cornerRadius = morningView.frame.size.height/2
            morningView.layer.masksToBounds = true
            morningView.backgroundColor = UIColor.init(hex: "39dee3")
            morningLabel.textColor = UIColor.white
            
            tvs![8].backgroundColor = UIColor.init(hex: "39d3e3")
            tls![8].textColor = UIColor.white
            
            mvs![0].backgroundColor = UIColor.init(hex: "39d3e3")
            mls![0].textColor = UIColor.white
        }
        */
    }
    
    func morningNoonChange(tag:Int)
    {
        for index in 0 ..< mns!.count
        {
            mns![index].backgroundColor = UIColor.white
            mnls![index].textColor = UIColor.init(hex: "333333")
        }
        selectedMorningnoon = tag
        mns![tag].backgroundColor = UIColor.init(hex: colorCode)
        mnls![tag].textColor = UIColor.white
    }
    
    func timeInitialize(hour:String,min:String)
    {
        morningView.layer.cornerRadius = morningView.frame.size.height/2
        morningView.layer.masksToBounds = true
        morningView.backgroundColor = UIColor.init(hex: colorCode)
        morningLabel.textColor = UIColor.white
        if Int(hour)! > 12
        {
            tvs![Int(hour)! - 1 - 12].backgroundColor = UIColor.init(hex: colorCode)
            tls![Int(hour)! - 1 - 12].textColor = UIColor.white
            selectedTime = Int(hour)! - 1 - 12
            morningNoonChange(tag: 1)
        }
        else {
            tvs![Int(hour)! - 1].backgroundColor = UIColor.init(hex: colorCode)
            tls![Int(hour)! - 1].textColor = UIColor.white
            selectedTime = Int(hour)! - 1
            morningNoonChange(tag: 0)
        }
        timeChange(tag: selectedTime)
        mvs![Int(min)!/5].backgroundColor = UIColor.init(hex: colorCode)
        mls![Int(min)!/5].textColor = UIColor.white
        selectedMinute = Int(min)!/5
        minuteChange(tag: selectedMinute)
        timeRange = DataUtils.getTimeRange(index: dayIndex)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func minuteChange(tag:Int)
    {
        for index in 0 ..< tvs!.count
        {
            mvs![index].backgroundColor = UIColor.white
            mls![index].textColor = UIColor.init(hex: "333333")
        }
        mvs![tag].backgroundColor = UIColor.init(hex: colorCode)
        
        mls![tag].textColor = UIColor.white
        selectedMinute = tag
        
        timeLabel.text = tls![selectedTime].text! + ":" + mls![selectedMinute].text!
    }
    
    func timeChange(tag:Int)
    {
        for index in 0 ..< tvs!.count
        {
            tvs![index].backgroundColor = UIColor.white
            tls![index].textColor = UIColor.init(hex: "333333")
            
        }
        tvs![tag].backgroundColor = UIColor.init(hex: colorCode)
        
        tls![tag].textColor = UIColor.white
        selectedTime = tag
        
        timeLabel.text = tls![selectedTime].text! + ":" + mls![selectedMinute].text!
    }
    
    @objc func morningnoonSelect(sender : UITapGestureRecognizer) {
        /*
        let tag = sender.view!.tag
        for index in 0 ..< mns!.count
        {
            mns![index].backgroundColor = UIColor.white
            mnls![index].textColor = UIColor.init(hex: "333333")
        }
        selectedMorningnoon = tag
        mns![tag].backgroundColor = UIColor.init(hex: "39d3e3")
        mnls![tag].textColor = UIColor.white
        */
        let tag = sender.view!.tag
        morningNoonChange(tag: tag)
    }
    
    @objc func timeSelect(sender : UITapGestureRecognizer) {
        /*
        let tag = sender.view!.tag
        print(tls![tag].text!)
        for index in 0 ..< tvs!.count
        {
            tvs![index].backgroundColor = UIColor.white
            tls![index].textColor = UIColor.init(hex: "333333")
            
        }
        tvs![tag].backgroundColor = UIColor.init(hex: "39d3e3")
        tls![tag].textColor = UIColor.white
        selectedTime = tag
        
        timeLabel.text = tls![selectedTime].text! + ":" + mls![selectedMinute].text!
        */
        let tag = sender.view!.tag
        print(tls![tag].text!)
        timeChange(tag: tag)
    }
    
    @objc func minuteSelect(sender : UITapGestureRecognizer) {
        /*
        let tag = sender.view!.tag
        print(mls![tag].text!)
        for index in 0 ..< tvs!.count
        {
            mvs![index].backgroundColor = UIColor.white
            mls![index].textColor = UIColor.init(hex: "333333")
        }
        mvs![tag].backgroundColor = UIColor.init(hex: "39d3e3")
        mls![tag].textColor = UIColor.white
        selectedMinute = tag
        
        timeLabel.text = tls![selectedTime].text! + ":" + mls![selectedMinute].text!
        */
        let tag = sender.view!.tag
        print(mls![tag].text!)
        minuteChange(tag: tag)
    }
    
    @objc func addNeededSelect(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: {
            self.delegate?.closeDialog()
            })
    }
    
    @objc func addNeededSelect1(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func gotoCancel(_ sender: Any) {
        dismiss(animated: false, completion: {
            self.delegate?.closeDialog1()
        })
    }
    
    @IBAction func gotoDone(_ sender: Any) {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let currentDate = formatter.string(from: currentDateTime)
        
        let date = timeLabel.text!.components(separatedBy: ":")
        var hourSet = Int(date[0])!
        let minSet = Int(date[1])!
        
        if selectedMorningnoon == 1
        {
            hourSet += 12
        }
        
        let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
        
        
        var hour = calendar.component(.hour, from: currentDateTime)
        var min = calendar.component(.minute, from: currentDateTime)
        
        let different = (hour - hourSet) * 3600 + (min - minSet) * 60
        
        /*
        if different < 0
        {
            DataUtils.messageShow(view: self, message: "Please check time settings", title: "")
            return
        }
        */
        let different1 = abs(different)
        hour = different1 / 3600
        min = (different1 % 3600) / 60
        var timeMsg = ""
        if different < 0
        {
            if hour > 0
            {
                timeMsg = "\(hour)h \(min) mins ago"
            }
            else{
                timeMsg = "\(min) mins ago"
            }
        }
        else {
            if hour > 0
            {
                timeMsg = "\(hour)h \(min) mins after"
            }
            else{
                timeMsg = "\(min) mins after"
            }
        }
        let medicationHistory = MedicationHistory.init(id: 0, medicationId: mymedication.id, date: currentDate, takeTime: timeLabel.text!, eatenTime: String(mymedication.prescription), eatText: quantiyValue.text! + " - " + timeMsg, medicationName: mymedication.medicationname, dayTime: mymedication.taketime,prescription: 1)
        let datas = [medicationHistory]
        DBManager.shared.insetMedicationHistoryData(datas: datas)
        
        dismiss(animated: false, completion: {
            self.delegate?.closeDialog1()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
