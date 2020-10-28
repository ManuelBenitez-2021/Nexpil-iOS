//
//  TenthMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TenthMedicationAddViewController: UIViewController,AMChoiceDelegate {

    @IBOutlet weak var whenselect: AMChoice!
    var selectedIndex = -1
    let myItems = [
        VoteModel(title: "Morning", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "Midday", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "Evening", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "Night", isSelected: false, isUserSelectEnable: true),
        ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        whenselect.delegate = self
        whenselect.data = myItems
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        present(viewController, animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 9
        appDelegate.pageViewController?.gotoPage()
    }
    
    @IBAction func gotoNext(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 11
        appDelegate.pageViewController?.gotoPage()
    }
    func didSelectRowAt(indexPath: IndexPath) {
        print("item at index \(indexPath.row) selected")
        selectedIndex = indexPath.row
        DataUtils.setMedicationWhen(name:myItems[selectedIndex].title)
    }
}
