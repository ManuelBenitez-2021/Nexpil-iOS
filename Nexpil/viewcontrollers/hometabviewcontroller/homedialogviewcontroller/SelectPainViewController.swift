//
//  SelectPainViewController.swift
//  Nexpil
//
//  Created by Admin on 4/19/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import fluid_slider

protocol DialogClose {
    func closeDialog()
    func closeDialog1()
}

class SelectPainViewController: UIViewController,DialogClose {
    
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var medicationname: UILabel!
    @IBOutlet weak var strength: UILabel!
    var mymedication = MyMedication()
    var quantityText = ""
    @IBOutlet weak var quantiyView: UIView!
    @IBOutlet weak var painView: UIView!
    @IBOutlet weak var quantitylabel: UILabel!
    @IBOutlet weak var painlabel: UILabel!
    @IBOutlet weak var painimage: UIImageView!
    
    var delegate:DialogClose?
    var severeString = ""
    @IBOutlet weak var painslider: Slider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainView.viewShadow()
        quantiyView.layer.cornerRadius = 10
        
        painView.viewShadow()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect(sender:)))
        
        quantiyView.addGestureRecognizer(gesture)
        
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(addNeededSelect1(sender:)))
        painimage.isUserInteractionEnabled = true
        painimage.addGestureRecognizer(gesture1)
        
        let labelTextAttributes: [NSAttributedStringKey : Any] = [.font: UIFont(name: "Montserrat-Regular", size: 18)!, .foregroundColor: UIColor.white]
        painslider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 2
            formatter.maximumFractionDigits = 0
            var string = ""
            /*
            if fraction >= 0 && fraction < 0.1
            {
                string = "1"
            }
            else {
                string = formatter.string(from: ((fraction) * 10) as NSNumber) ?? ""
            }
            */
            string = formatter.string(from: ((fraction) * 10) as NSNumber) ?? ""
            if string == "0"
            {
                self.painlabel.text = "No Pain"
                self.painimage.image = UIImage(named: "0 -1 No Pain")
            }
            else {
                self.painlabel.text = "Severe Pain"
                self.painimage.image = UIImage(named: "6 - 7 Severe Pain")
            }
            self.severeString = string
            return NSAttributedString(string: string, attributes: [.font: UIFont(name: "Montserrat-Regular", size: 18)!, .foregroundColor: UIColor.init(hex: "ec877c")])
        }
        painslider.setMinimumLabelAttributedText(NSAttributedString(string: "0", attributes: labelTextAttributes))
        painslider.setMaximumLabelAttributedText(NSAttributedString(string: "10", attributes: labelTextAttributes))
        painslider.fraction = 0
        painslider.shadowOffset = CGSize(width: 0, height: 10)
        painslider.shadowBlur = 5
        painslider.shadowColor = UIColor(white: 0, alpha: 0.1)
        painslider.contentViewColor = UIColor.init(hex: "e34939")//UIColor(red: 78/255.0, green: 77/255.0, blue: 224/255.0, alpha: 1)
        painslider.valueViewColor = .white
        
        
        painslider.contentViewCornerRadius = painslider.frame.size.height/2
        
    }

    func closeDialog1() {
        dismiss(animated: false, completion: {
            self.delegate?.closeDialog()
        })
    }
    
    func closeDialog() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func addNeededSelect(sender : UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func addNeededSelect1(sender : UITapGestureRecognizer) {
        if severeString != "0"
        {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectTimeViewController") as! SelectTimeViewController
            
            viewController.mymedication = mymedication
            viewController.delegate = self
            viewController.quantity = quantityText
            viewController.painScore = severeString
            present(viewController, animated: false, completion: nil)
        }
        else
        {
            dismiss(animated: false, completion: {
                self.delegate?.closeDialog()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        medicationname.text = mymedication.medicationname
        strength.text = mymedication.strength
        quantitylabel.text = quantityText
        
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        dismiss(animated: false, completion: {
            self.delegate?.closeDialog()
        })
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
