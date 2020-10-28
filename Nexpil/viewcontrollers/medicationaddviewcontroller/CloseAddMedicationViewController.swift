//
//  CloseAddMedicationViewController.swift
//  Nexpil
//
//  Created by Admin on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class CloseAddMedicationViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    var delegate:ShadowDelegate1?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainView.viewShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeNo(_ sender: Any) {
        self.delegate?.removeShadow(root: false)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func closeYes(_ sender: Any) {
        self.dismiss(animated: false, completion: {
            self.delegate?.removeShadow(root: true)
            /*
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if DataUtils.getPrescription() == 0
            {
                appDelegate.pageViewController?.closePageViewController()
            }
            else {
                appDelegate.vitaminPageViewController?.closePageViewController()
            }
            */
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
