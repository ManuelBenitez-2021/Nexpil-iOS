//
//  MedicationInfoMainViewController.swift
//  Nexpil
//
//  Created by Admin on 4/27/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class MedicationInfoMainViewController1: ButtonBarPagerTabStripViewController {

    var myMedication:MedicationHistory?
    
    var medicationId = 0
    
    
    @IBOutlet weak var takeView: UIView!
    @IBOutlet weak var takeLabel: UILabel!
    @IBOutlet weak var medicationName1: UILabel!
    @IBOutlet weak var takeTime: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var takeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var medicationName: UILabel!
    @IBOutlet weak var strength: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        containerView.isScrollEnabled = false
        // Do any additional setup after loading the view.
        
        barSettings()
        
    }

    func takeButtonInitialize()
    {
        takeViewHeight.constant = 44
        takeView.backgroundColor = UIColor.init(hex: "39d3e3")
        takeLabel.text = "Take " + medicationName.text!
        medicationName1.isHidden = true
        checkImage.isHidden = true
        takeTime.isHidden = true
        takeView.viewUnShadow()
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.takeMedication))
        takeView.addGestureRecognizer(gesture2)
    }
    func takeButtonSet(time:String)
    {
        takeViewHeight.constant = 60
        takeView.backgroundColor = UIColor.init(hex: "ffffff")
        takeLabel.text = "Take " + medicationName.text!
        takeLabel.isHidden = true
        medicationName1.isHidden = false
        checkImage.isHidden = false
        takeTime.isHidden = false
        takeTime.text = time
        takeView.viewShadow()
        medicationName1.text = medicationName.text
        takeView.isUserInteractionEnabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        medicationName.text = myMedication!.medicationName
        takeButtonInitialize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DirectionViewController") as! DirectionViewController
        child_1.medicationId = self.myMedication!.medicationId
        child_1.getMedicationInfo()
        let child_2 = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        child_2.medicationName = self.myMedication!.medicationName
        return [child_1,child_2]
        //return [child_2,child_3,child_4]
        
    }
    
    func barSettings()
    {
        
        buttonBarView.selectedBar.backgroundColor = UIColor.init(hex: "39d3e3")
        settings.style.buttonBarBackgroundColor = UIColor.init(hex: "f7f7fa")
        settings.style.buttonBarItemBackgroundColor = UIColor.init(hex: "f7f7fa")
        settings.style.selectedBarBackgroundColor = UIColor.init(hex: "f7f7fa")
        settings.style.buttonBarItemFont = UIFont(name: "Montserrat-Medium", size: 18)!
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.init(hex: "333333")
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
    
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else {
                return }
            
            oldCell?.isSelected = false
            oldCell?.isHighlighted = false
            oldCell?.label.textColor = UIColor.init(hex: "333333").withAlphaComponent(0.5)
            
            
            //newCell?.label.textColor = UIColor.init(hex: "01A2DD")
            //oldCell?.imageView.image = oldCell?.imageView.image
            
            
            newCell?.isHighlighted = true
            newCell?.label.textColor = UIColor.init(hex: "39d3e3")
            
            
        }
        
        
    }
    @IBAction func closeWindow(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
        
    }
    @objc func takeMedication(sender : UITapGestureRecognizer) {
    //@IBAction func takeDrug(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a "
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        let currentDateTime = Date()
        let time = formatter.string(from: currentDateTime)
        if myMedication!.prescription == 0
        {
            DBManager.shared.saveMedicationInfo(id: myMedication!.id, eatTime: time, eatText: "1 tablet - Taken " + time)
        }
        else {
            var myMedications:[MedicationHistory] = []
            myMedication!.eatenTime = time
            myMedication!.eatText = "1 tablet - Taken"
            myMedications.append(myMedication!)
            DBManager.shared.insetMedicationHistoryData(datas: myMedications)
        }
        //DataUtils.messageShow(view: self, message: "Successfully updated", title: "")
        takeButtonSet(time: "1 tablet - Taken at " + time)
    }
    
    @IBAction func removeDrug(_ sender: Any) {
        let _ = DBManager.shared.deleteMedicationDrug(id: myMedication!.id)
        deleteDrug()
        
    }
    
    func deleteDrug()
    {
        let params = [
            "drugid" : myMedication!.medicationId,
            "choice" : "3"
            
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
                        
                        let message = json["message"] as! String
                        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                            self.navigationController?.popViewController(animated: false)
                        }
                        alert.addAction(OKAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        let message = json["message"] as! String
                        DataUtils.messageShow(view: self, message: message, title: "")
                    }
                }
            })
    }
    
}
