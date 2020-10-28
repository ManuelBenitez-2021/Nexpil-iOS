//
//  EightMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import SkyFloatingLabelTextField

class EightMedicationAddViewController: UIViewController,ShadowDelegate {
    
    

    @IBOutlet weak var tablets: UITextField!
    @IBOutlet weak var txtView: UIView!
    
    @IBOutlet weak var backBtn: GradientView!
    
    @IBOutlet weak var cameraButton: GradientView!
    @IBOutlet weak var nextBtn: GradientView!
    var visualEffectView:VisualEffectView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //tablets.titleFormatter = { $0 }
        self.hideKeyboardWhenTappedAround()
        
        txtView.viewShadow()
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture2)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        
        visualEffectView = self.view.backgroundBlur(view: self.view)
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoCamera))
        cameraButton.addGestureRecognizer(gesture3)
        
    }
    
    @objc func gotoCamera(sender : UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabletCountViewController") as! TabletCountViewController        
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1 //6
        appDelegate.pageViewController?.gotoPage()
    }
    
    func removeShadow() {
        visualEffectView?.removeFromSuperview()
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        if tablets.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input amount", title: "")
            return
        }
        DataUtils.setStartTablet(name: tablets.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1 //8
        appDelegate.pageViewController?.gotoPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeWindow(_ sender: Any) {
        self.view.addSubview(visualEffectView!)
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        //viewController.delegate = self
        viewController.modalPresentationStyle = .overCurrentContext
        present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func cameraCounts(_ sender: Any) {
        
    }
    
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage - 1 //6
        appDelegate.pageViewController?.gotoPage()
    }
    @IBAction func gotoNext(_ sender: Any) {
        if tablets.text!.isEmpty
        {
            DataUtils.messageShow(view: self, message: "Please input amount", title: "")
            return
        }
        DataUtils.setStartTablet(name: tablets.text!)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = appDelegate.pageViewController!.pageControl.currentPage + 1 //8
        appDelegate.pageViewController?.gotoPage()
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
