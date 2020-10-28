//
//  TabletSelectDialogViewController.swift
//  Nexpil
//
//  Created by Admin on 4/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class TabletSelectDialogViewController: UIViewController,DialogClose {
    func closeDialog1() {
        
    }
    
    func closeDialog() {
        dismiss(animated: false, completion: nil)
    }
    

    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var strength: UILabel!
    @IBOutlet weak var onetabletView: UIView!
    @IBOutlet weak var twotabletView: UIView!
    @IBOutlet weak var twotabletimageview: UIImageView!
    @IBOutlet weak var onetabletimageview: UIImageView!
    var mymedication = MyMedication()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainview.viewShadow()
        onetabletView.viewShadow()
        twotabletView.viewShadow()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect(sender:)))
        onetabletView.tag = 0
        onetabletView.addGestureRecognizer(gesture)
        twotabletView.tag = 1
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect1(sender:)))
        twotabletView.addGestureRecognizer(gesture1)
        
    }
    @objc func addNeededSelect(sender : UITapGestureRecognizer) {
        showSelect(id:0)
        
    }
    @objc func addNeededSelect1(sender : UITapGestureRecognizer) {
        showSelect(id:1)
    }
    func showSelect(id:Int) {
        
        onetabletView.backgroundColor = UIColor.init(hex: "ffffff")
        twotabletView.backgroundColor = UIColor.init(hex: "ffffff")
        
        onetabletimageview.image = UIImage(named: "1 Pill")
        twotabletimageview.image = UIImage(named: "pills by Ale Em from the Noun Project")
        
        var quantityText = ""
        switch id {
        case 0:
            onetabletView.backgroundColor = UIColor.init(hex: "39d3e3")
            onetabletimageview.image = UIImage(named: "1 Pill-1")
            quantityText = "1 Tablet"
        case 1:
            twotabletView.backgroundColor = UIColor.init(hex: "39d3e3")
            twotabletimageview.image = UIImage(named:"2 Pill")
            quantityText = "2 Tablets"
        default:
            break
        }
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectPainViewController") as! SelectPainViewController
        viewController.mymedication = mymedication
        viewController.delegate = self
        viewController.quantityText = quantityText
        present(viewController, animated: false, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        medicationname.text = mymedication.medicationname
        strength.text = mymedication.strength
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: false, completion: nil)
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
