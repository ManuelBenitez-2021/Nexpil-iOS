//
//  FirstViewViewController.swift
//  Nexpil
//
//  Created by Admin on 4/6/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class FirstViewViewController: UIViewController {

    @IBOutlet weak var maintitle: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var imageViews: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainView1: UIView!
    @IBOutlet weak var first: UIView!
    @IBOutlet weak var second: UIView!
    @IBOutlet weak var third: UIView!
    
    
    @IBOutlet weak var signInBtn: GradientView!
    @IBOutlet weak var newUserBtn: GradientView!
    var indicators:[UIView]?
    let maincontent = ["Welcome to nexpil","Account Protection","Community"]
    let subcontent = ["We believe that managing your health \r\nshould be easy.","Personal data should be shared with \r\npeople you decide to share it with.","Life is better when we are \r\nconnected to those we care about."]
    let content1 = ["Swipe to learn more","Swipe to learn more","Swipe to learn more"]
    let images = ["dot_logo","hippa_","comm_"]
    //@IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var starImage: UIImageView!
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        DataUtils.setSkipButton(time: false)
        
        // Do any additional setup after loading the view.
        
        //let pageCount : CGFloat = CGFloat(maincontent.count)
        
        //pageControl.numberOfPages = Int(pageCount)
        //pageControl.addTarget(self, action: #selector(self.pageChanged), for: .valueChanged)
        
        
        //mainView1.viewShadow()
        
        //mainView1.backgroundColor = UIColor(white: 1, alpha: 0.5)
        mainView.viewShadow()
        mainView1.viewShadow()
        //mainView1.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        //pageControl.pageIndicatorTintColor = UIColor.lightGray
        //pageControl.currentPageIndicatorTintColor = UIColor.init(hex: "43D5E4")
        //pageControl.transform = CGAffineTransform(scaleX: 2, y: 2); // Looks better!
        
        indicators = [first,second,third]
        for index in 0 ..< indicators!.count
        {
            let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(pageChanged(sender:)))
            indicators![index].tag = index
            indicators![index].addGestureRecognizer(gesture2)
        }
        
        updatePageControl(left:true)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.gotoSignIn))
        signInBtn.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.gotoNewUser))
        newUserBtn.addGestureRecognizer(gesture1)
        addSwipe()
        
        
    }
    
    @objc func gotoSignIn(sender : UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginviewcontroller") as! LoginViewController
        present(viewController, animated: false, completion: nil)
    }
    
    @objc func gotoNewUser(sender : UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewUserViewController") as! NewUserViewController
        present(viewController, animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        medicationInit()
    }
    
    func medicationInit()
    {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "usertype")
        DataUtils.setPatientFullName(patientfullname: "")
        DataUtils.setPharmacyName(pharmacy: "")
        DataUtils.setMedicationName(name: "")
        DataUtils.setMedicationStrength(name: "")
        DataUtils.setMedicationDate(name: "")
        DataUtils.setMedicationDose(name: "")
        DataUtils.setMedicationFrequency(name: "")
        DataUtils.setStartTablet(name: "")
        DataUtils.setLeftTablet(name: "")
        DataUtils.setPrescribed(name: "")
        DataUtils.setMedicationWhen(name: "")
    }
    
    func addSwipe() {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
            gesture.direction = direction
            self.mainView1.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleSwipe(_ sender : UISwipeGestureRecognizer){
        print(sender.direction)
        if sender.direction == .left
        {
            
            if currentIndex < 2
            {
                currentIndex = currentIndex + 1
                updatePageControl(left:true)
                
            }
        }
        if sender.direction == .right
        {
            
            if currentIndex > 0
            {
                currentIndex = currentIndex - 1
                updatePageControl(left:false)
                
            }
        }
    }
    
    func updatePageControl(left:Bool) {
        
        maintitle.text = maincontent[currentIndex]
        subtitle.text = subcontent[currentIndex]
        content.text = content1[currentIndex]
        imageViews.image = UIImage(named: images[currentIndex])
        for index in 0 ..< indicators!.count
        {
            indicators![index].backgroundColor = UIColor.init(hex: "9f97ee")
        }
        indicators![currentIndex].backgroundColor = UIColor.init(hex: "4939e3")
        /*
        if currentIndex == 0
        {
            starImage.isHidden = false
        }
        else {
            starImage.isHidden = true
        }
        */
        if left == true
        {
            UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
                var basketTopFrame = self.mainView1.frame
                basketTopFrame.origin.x += basketTopFrame.size.width
                
                var basketBottomFrame = self.mainView1.frame
                basketBottomFrame.origin.x -= basketBottomFrame.size.width
                
                self.mainView1.frame = basketTopFrame
                self.mainView1.frame = basketBottomFrame
            }, completion: { finished in
                print("Basket doors opened!")
            })
        }
        else {
            
                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseIn, animations: {
                    var basketTopFrame = self.mainView1.frame
                    basketTopFrame.origin.x -= basketTopFrame.size.width
                    
                    var basketBottomFrame = self.mainView1.frame
                    basketBottomFrame.origin.x += basketBottomFrame.size.width
                    
                    self.mainView1.frame = basketTopFrame
                    self.mainView1.frame = basketBottomFrame
                }, completion: { finished in
                    print("Basket doors opened!")
                })
            
        }
    }
    
    @objc func pageChanged(sender : UITapGestureRecognizer) {
        if sender.view!.tag > currentIndex
        {
            currentIndex = sender.view!.tag
            updatePageControl(left:false)
        }
        else {
            currentIndex = sender.view!.tag
            updatePageControl(left:true)
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
