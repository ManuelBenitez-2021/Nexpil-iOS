//
//  DirectionViewController.swift
//  Nexpil
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
class DirectionViewController: UIViewController {
    var medicationId = 0
    
    @IBOutlet weak var takelabel: UILabel!
    @IBOutlet weak var takeview: UIView!
    @IBOutlet weak var descriptionview: UIView!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var treatview: UIView!
    @IBOutlet weak var treatlabel: UILabel!
    @IBOutlet weak var reminderview: UIView!
    @IBOutlet weak var reminderlabel: UILabel!
    @IBOutlet weak var startedview: UIView!
    @IBOutlet weak var startedlabel: UILabel!
    @IBOutlet weak var quantityview: UIView!
    @IBOutlet weak var quantiylabel: UILabel!
    @IBOutlet weak var prescriptionview: UIView!
    @IBOutlet weak var prescriptionlabel: UILabel!
    @IBOutlet weak var remainingview: UIView!
    @IBOutlet weak var remininglabel: UILabel!
    @IBOutlet weak var refillreminderview: UIView!
    @IBOutlet weak var refillreminderlabel: UILabel!
    @IBOutlet weak var prescriptionnumberview: UIView!
    @IBOutlet weak var prescriptionnumberlabel: UILabel!
    @IBOutlet weak var prescriptionbyview: UIView!
    @IBOutlet weak var prescriptionbylabel: UILabel!
    @IBOutlet weak var storeview: UIView!
    @IBOutlet weak var pharmacynamelabel: UILabel!
    @IBOutlet weak var phonenumberlabel: UILabel!
    @IBOutlet weak var addresslabel: UILabel!
    @IBOutlet weak var pharmacyimage: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    var patientmedications : [MyMedication] = []
    var descriptionviewHeight:CGFloat = 0.0
    @IBOutlet weak var scrollviewheight: NSLayoutConstraint!
    var originalscrollviewheight:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takeview.layer.cornerRadius = 10
        descriptionview.viewShadow()
        treatview.viewShadow()
        reminderview.viewShadow()
        startedview.viewShadow()
        quantityview.viewShadow()
        remainingview.viewShadow()
        refillreminderview.viewShadow()
        //prescriptionview.viewShadow()
        prescriptionbyview.viewShadow()
        prescriptionnumberview.viewShadow()
        storeview.viewShadow()
        
        // Do any additional setup after loading the view.
        //getMedicationInfo()
        self.descriptionviewHeight = descriptionview.frame.size.height
        originalscrollviewheight = mainView.frame.size.height
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

    func getMedicationInfo()
    {
        let params = [
            "medicationId" : medicationId,
            "choice" : "7"
            
            ] as [String : Any]
        DataUtils.customActivityIndicatory(self.view,startAnimate: true)
        Alamofire.request(DataUtils.APIURL + DataUtils.MYDRUG_URL, method: .post, parameters: params)
            .responseJSON(completionHandler: { response in
                
                DataUtils.customActivityIndicatory(self.view,startAnimate: false)
                
                debugPrint(response);
                
                if let data = response.result.value {
                    print("JSON: \(data)")
                    let json : [String:Any] = data as! [String : Any]
                    
                    let result = json["status"] as? String
                    if result == "true"
                    {
                        self.patientmedications.removeAll()
                        let datas:[[String:Any]] = json["data"] as! [[String:Any]]
                        for obj in datas {
                            let patientMedication = MyMedication.init(json: obj)
                            self.patientmedications.append(patientMedication)
                            
                        }
                        if self.patientmedications.count > 0
                        {
                            self.showDirections()
                        }
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    func showDirections()
    {
        let mymedication = patientmedications[0]
        treatlabel.text = mymedication.type
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        descriptionlabel.text = "Take 30 minutes before a meal. If you take this medicine once daily, take it 30 minutes before breakfast."
        
        if mymedication.createat != ""
        {
            reminderlabel.text = mymedication.createat.components(separatedBy: " ")[1] + " " + mymedication.frequency
        }
        else {
            let currentDate = Date()
            formatter.dateFormat = "HH:mm"
            reminderlabel.text = formatter.string(from: currentDate) + " " + mymedication.frequency
        }
        
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if mymedication.createat != ""
        {
            let date = formatter.date(from: mymedication.createat)
            
            formatter.dateFormat = "MMMM d,yyyy"
            startedlabel.text = formatter.string(from: date!)
        }
        else {
            let currentDate = Date()
            formatter.dateFormat = "MMMM d,yyyy"            
            startedlabel.text = formatter.string(from: currentDate)
        }
        quantiylabel.text = mymedication.quantity
        remininglabel.text = "No Refills Left"
        refillreminderlabel.text = mymedication.lefttablet + " \(mymedication.type)s Remaining"
        prescriptionnumberlabel.text = "1234567-12345"
        prescriptionbylabel.text = mymedication.prescribe
        pharmacynamelabel.text = mymedication.pharmacy
        phonenumberlabel.text = "(312)970-2822"
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        let desc = descriptionview.frame.size.height
        scrollviewheight.constant = originalscrollviewheight + (desc - descriptionviewHeight)
        //self.view.frame.size.height = scrollviewheight.constant
    }
}

extension DirectionViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Directions")
    }
}
