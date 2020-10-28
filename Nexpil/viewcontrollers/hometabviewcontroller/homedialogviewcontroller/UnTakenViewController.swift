//
//  UnTakenViewController.swift
//  Nexpil
//
//  Created by Admin on 4/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Alamofire

class UnTakenViewController: UIViewController {
    
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    
    var medicationId = 0
    var takeMedication:MedicationHistory?
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
        
        
        mainView.viewShadow()
        
        morningLabel.text = "AM"
        noonLabel.text = "PM"
        
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
        
        let historys = DBManager.shared.getMedicationInfosById(id:medicationId)
        takeMedication = historys[0]
        let taketime = takeMedication!.takeTime
        let hour = taketime.components(separatedBy: ":")[0]
        let min = taketime.components(separatedBy: ":")[1]
        
        if takeMedication!.dayTime == "Morning"
        {
            colorCode = "39d3e3"
            dayIndex = 0
        }
        if takeMedication!.dayTime == "Midday"
        {
            colorCode = "397EE3"
            dayIndex = 1
        }
        if takeMedication!.dayTime == "Evening"
        {
            colorCode = "415CE3"
            dayIndex = 2
        }
        if takeMedication!.dayTime == "Night"
        {
            colorCode = "4939E3"
            dayIndex = 3
        }
        timeInitialize(hour: hour, min: min)
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
    
    @objc func morningnoonSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        morningNoonChange(tag: tag)
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
    
    @objc func timeSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        print(tls![tag].text!)
        timeChange(tag: tag)
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
    
    @objc func minuteSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        print(mls![tag].text!)
        minuteChange(tag: tag)
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
    
    @IBAction func gotoCancel(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func gotoDone(_ sender: Any) {
        //if takeMedication!.dayTime == "Morning"
        //{
            let range = DataUtils.getTimeRange(index: dayIndex)!
            let startRange = range.components(separatedBy: "-")[0]
            let endRange = range.components(separatedBy: "-")[1]
            let startValue = Int(startRange.components(separatedBy: ":")[0])! * 60 + Int(startRange.components(separatedBy: ":")[1])!
            let endValue = Int(endRange.components(separatedBy: ":")[0])! * 60 + Int(endRange.components(separatedBy: ":")[1])!
            
            let date = timeLabel.text!.components(separatedBy: ":")
            var hourSet = Int(date[0])!
            let minSet = Int(date[1])!
            
            if selectedMorningnoon == 1
            {
                hourSet += 12
            }
            let value = hourSet * 60 + minSet
            if startValue < value && value < endValue
            {
                let hour = timeLabel.text!.components(separatedBy: ":")[0]
                var updateTime = ""
                if selectedMorningnoon == 1
                {
                    updateTime = String(Int(hour)! + 12) + ":" + timeLabel.text!.components(separatedBy: ":")[1]
                }
                else {
                    updateTime = timeLabel.text!
                }
                //time set
                DBManager.shared.updateMedicationTakeTime(id: takeMedication!.id, eatTime: "", eatText: "", taketime: updateTime)
                updateTakeTime()
            }
            else{
                DataUtils.messageShow(view: self, message: "Please select \(range)" , title: "")
                return
            }
        //}
    }
    
    func updateTakeTime() {
        let hour = timeLabel.text!.components(separatedBy: ":")[0]
        var updateTime = ""
        if selectedMorningnoon == 1
        {
            updateTime = String(Int(hour)! + 12) + ":" + timeLabel.text!.components(separatedBy: ":")[1]
        }
        else {
            updateTime = timeLabel.text!
        }
        let params = [
            "time" : updateTime,
            "medicationId" : takeMedication!.medicationId,
            "choice" : "6"
            
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    //let statusMsg: String = json["status_msg"] as! String
                    //self.showResultMessage(statusMsg)
                    //self.showGraph(json)
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.dismiss(animated: false, completion: nil)
                        return
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
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
