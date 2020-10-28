//
//  SeventhMedicationAddViewController.swift
//  Nexpil
//
//  Created by Admin on 4/8/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class SeventhMedicationAddViewController: UIViewController,AMChoiceDelegate {

    var selectedIndex = -1
    @IBOutlet weak var tabletsSelect: AMChoice!
    let myItems = [
        VoteModel(title: "30 Tablets", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "60 Tablets", isSelected: false, isUserSelectEnable: true),
        VoteModel(title: "90 Tablets", isSelected: false, isUserSelectEnable: true),
        
        ]
    @IBOutlet weak var helpview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabletsSelect.delegate = self
        tabletsSelect.data = myItems
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.showImage))
        helpview.layer.cornerRadius = 10.0
        helpview.layer.masksToBounds = true
        helpview.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloseAddMedicationViewController") as! CloseAddMedicationViewController
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func showImage(sender : UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HelpImageViewController") as! HelpImageViewController
        viewController.imageName = "tabletshelpimage.png"
        present(viewController, animated: false, completion: nil)
    }
    @IBAction func gotoBack(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 3
        appDelegate.pageViewController?.gotoPage()
    }
    @IBAction func gotNext(_ sender: Any) {
        
        if selectedIndex == -1
        {
            DataUtils.messageShow(view: self, message: "Please select tablet", title: "")
            return
        }
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pageViewController?.pageControl.currentPage = 5
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
    
    func didSelectRowAt(indexPath: IndexPath) {
        print("item at index \(indexPath.row) selected")
        selectedIndex = indexPath.row
        DataUtils.setStartTablet(name: myItems[indexPath.row].title)
    }
    
}
