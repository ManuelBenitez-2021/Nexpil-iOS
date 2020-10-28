//
//  NewUserViewController.swift
//  Nexpil
//
//  Created by Admin on 4/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
    var selectedIndex = -1
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    var views:[UIView]?
    var labels:[UILabel]?
    var images:[UIImageView]?
    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    
    @IBOutlet weak var backBtn: GradientView!
    @IBOutlet weak var nextBtn: GradientView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view1.viewShadow()
        view2.viewShadow()
        views = [view1,view2]
        labels = [label1,label2]
        images = [check1,check2]
        for index in 0 ..< views!.count
        {
            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(timeSelect(sender:)))
            views![index].tag = index
            views![index].addGestureRecognizer(gesture2)
            
        }
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if selectedIndex != -1
        {
            displayStatus(tag: selectedIndex)
        }
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        if selectedIndex != -1
        {
            if selectedIndex == 0
            {
                DataUtils.setPatient(time: "patient")
            }
            else
            {
                DataUtils.setPatient(time: "caregiver")
            }
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectMedicationViewController2") as! SelectMedicationViewController1
            present(viewController, animated: false, completion: nil)
        }
    }
    
    @objc func timeSelect(sender : UITapGestureRecognizer) {
        let tag = sender.view!.tag
        displayStatus(tag: tag)
        
    }
    
    func displayStatus(tag:Int)
    {
        for index in 0 ..< views!.count
        {
            labels![index].textColor = UIColor.init(hex: "333333")
            views![index].backgroundColor = UIColor.init(hex: "ffffff")
            images![index].isHidden = false
            views![index].viewShadow()
        }
        views![tag].backgroundColor = UIColor.init(hex: "39d3e3")
        labels![tag].textColor = UIColor.white
        images![tag].isHidden = true
        selectedIndex = tag
        views![tag].viewUnShadow()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    @IBAction func gotoBack(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    */
    @IBAction func gotoNext(_ sender: Any) {
        if selectedIndex != -1
        {
            if selectedIndex == 0
            {
                DataUtils.setPatient(time: "patient")
            }
            else
            {
                DataUtils.setPatient(time: "caregiver")
            }
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectMedicationViewController2") as! SelectMedicationViewController1
            present(viewController, animated: false, completion: nil)
        }
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
