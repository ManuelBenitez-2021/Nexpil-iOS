//
//  ManualSelectDialog.swift
//  Nexpil
//
//  Created by Admin on 6/4/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ManualSelectDialog: UIViewController {

    var delegate:ShadowDelegate?
    
    @IBOutlet weak var tryButton: GradientView!
    @IBOutlet weak var manualButton: GradientView!
    @IBOutlet weak var descriptionLabel: UILabel!
    let desc = ["We could not read the barcode clearly. Do you want to try again or enter the information manually?","We could not read the prescription label. Do you want to try again or enter the information manually?"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.tryAgain))
        tryButton.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.enterManually))
        manualButton.addGestureRecognizer(gesture1)
        if DataUtils.getPrescription() == 0
        {
            descriptionLabel.text = desc[1]
        }
        else{
            descriptionLabel.text = desc[0]
        }
    }

    @objc func tryAgain(sender : UITapGestureRecognizer) {
        self.delegate?.removeShadow()
        dismiss(animated: false, completion: nil)
    }
    
    @objc func enterManually(sender : UITapGestureRecognizer) {
        self.delegate?.removeShadow()
        dismiss(animated: false, completion: nil)
        if DataUtils.getPrescription() == 0
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.pageViewController?.pageControl.currentPage = 1
            appDelegate.pageViewController?.gotoPage()
        }
        else {
            //vitamin
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.vitaminPageViewController?.pageControl.currentPage = 1
            appDelegate.vitaminPageViewController?.gotoPage()
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

}
