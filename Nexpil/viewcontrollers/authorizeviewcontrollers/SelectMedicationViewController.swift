//
//  SelectMedicationViewController.swift
//  Nexpil
//
//  Created by Admin on 4/10/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol ShadowDelegate {
    func removeShadow()
    
}

protocol ShadowDelegate1 {
    func removeShadow(root: Bool)
    
}
protocol ShadowDelegate2 {
    func removeShadow1(root: Bool)
    
}
class SelectMedicationViewController: UIViewController,ShadowDelegate {
    func removeShadow() {
        visualEffectView!.removeFromSuperview()
    }
    

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextbtn: UIButton!
    @IBOutlet weak var backBtn: GradientView!
    @IBOutlet weak var nextBtn: GradientView!
    var visualEffectView:VisualEffectView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice().userInterfaceIdiom == .phone {
            print(UIScreen.main.nativeBounds.width)
            if UIScreen.main.nativeBounds.width < 650
            {
                label.font = UIFont(name: "Montserrat-Medium", size: 17)
            }
        }
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNext1))
        nextBtn.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoBack))
        backBtn.addGestureRecognizer(gesture1)
        visualEffectView = self.view.backgroundBlur(view: self.view)
    }
    
    @objc func gotoBack(sender : UITapGestureRecognizer) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc func gotoNext1(sender : UITapGestureRecognizer) {
        self.view.addSubview(visualEffectView!)
        let pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMedicationDialogViewController") as! AddMedicationDialogViewController        
        pageViewController.modalPresentationStyle = .overCurrentContext
        //pageViewController.delegate = self
        present(pageViewController, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gotoBack(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func gotoNext(_ sender: Any) {
        /*
        DataUtils.setSkipButton(time: false)
        let pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController = pageViewController
        present(pageViewController, animated: false, completion: nil)
        */
        let pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMedicationDialogViewController") as! AddMedicationDialogViewController
        
        present(pageViewController, animated: false, completion: nil)
        
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
